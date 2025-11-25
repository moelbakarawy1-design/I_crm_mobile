import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart' hide Data;
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/data/repo/chat_repo.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final MessagesRepository messagesRepository;
  final SocketService socketService;

  StreamSubscription? _messageSubscription;

  ChatCubit(this.chatRepository, this.messagesRepository, this.socketService)
      : super(ChatInitial());

  ChatModelNEW? allChats;
  List<Data> filteredChats = [];
  String currentSearchQuery = ''; // 🔍 Track current search

  Future<void> fetchAllChats() async {
    emit(ChatLoading());
    try {
      final chatModel = await chatRepository.getAllChats();
      if (isClosed) return;
      allChats = chatModel;
      filteredChats = chatModel.data ?? [];      
      // 🔍 If there's an active search, reapply it
      if (currentSearchQuery.isNotEmpty) {
        searchChats(currentSearchQuery);
      } else {
        emit(ChatListLoaded(chatModel));
      }
      
      _setupSocketListeners();
    } catch (e) {
      if (isClosed) return;
      emit(ChatError(e.toString()));
    }
  }

  Future<void> assignChat(String chatId, String userId) async {
    emit(ChatActionLoading());
    try {
      final response = await chatRepository.assignChat(chatId, userId);
      if (response.status == true) {
        emit(ChatActionSuccess(response.message));
        await fetchAllChats();
      } else {
        emit(ChatActionError(response.message));
      }
    } catch (e) {
      emit(ChatActionError(e.toString()));
    }
  }

  Future<void> renameChat(String chatId, String newName) async {
    emit(ChatActionLoading());
    try {
      final response = await chatRepository.renameChat(chatId, newName);
      if (response.status == true) {
        emit(ChatActionSuccess(response.message));
        await fetchAllChats();
      } else {
        emit(ChatActionError(response.message));
      }
    } catch (e) {
      emit(ChatActionError(e.toString()));
    }
  }

  Future<void> deleteChat(String chatId) async {
    emit(ChatLoading());
    try {
      final response = await chatRepository.deleteChat(chatId);
      if (response.status == true) {
        await fetchAllChats();
      } else {
        emit(ChatError(response.message));
      }
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _setupSocketListeners() async {
    await socketService.connect();
    _messageSubscription?.cancel();
    _messageSubscription = socketService.newMessageStream.listen((data) {
      _handleNewMessage(data);
    });
  }

  void _handleNewMessage(dynamic data) {
    if (isClosed || allChats?.data == null) return;

    try {
      dynamic processedData = data;
      if (data is List && data.isNotEmpty) processedData = data[0];

      final jsonPayload = (processedData is Map && processedData.containsKey('data'))
          ? processedData['data']
          : processedData;

      final newMessage = OrderedMessages.fromJson(jsonPayload);
      final chatId = newMessage.chatId;

      final index = allChats!.data!.indexWhere((c) => c.id == chatId);

      if (index != -1) {
        var chatToUpdate = allChats!.data![index];

        chatToUpdate.messages ??= [];
        chatToUpdate.messages!.add(Messages(
          id: newMessage.id,
          content: newMessage.content,
          timestamp: newMessage.timestamp,
          type: newMessage.type,
        ));

        allChats!.data!.removeAt(index);
        allChats!.data!.insert(0, chatToUpdate);

        // 🔍 Reapply search if active
        if (currentSearchQuery.isNotEmpty) {
          searchChats(currentSearchQuery);
        } else {
          filteredChats = List.from(allChats!.data!);
          emit(ChatListLoaded(ChatModelNEW(
            message: allChats!.message,
            data: List.from(allChats!.data!),
            success: allChats!.success,
          )));
        }
      } else {
        fetchAllChats();
      }
    } catch (e) {
      print("❌ Error updating Chat List UI: $e");
    }
  }

  //  Improved Search logic
  void searchChats(String query) {
    currentSearchQuery = query; // Save current search query
    
    if (allChats == null || allChats!.data == null) {
      return;
    }

    if (query.trim().isEmpty) {
      filteredChats = List.from(allChats!.data!);
      emit(ChatListLoaded(ChatModelNEW(
        message: allChats!.message,
        data: filteredChats,
        success: allChats!.success,
      )));
    } else {
      final lowerQuery = query.toLowerCase().trim();
      
      filteredChats = allChats!.data!.where((chat) {
        final customerName = chat.customer?.name?.toLowerCase() ?? '';
        final customerPhone = chat.customer?.phone?.toLowerCase() ?? '';
        final matches = customerName.contains(lowerQuery) || customerPhone.contains(lowerQuery);
        
        if (matches) {
        }
        return matches;
      }).toList();
      
      emit(ChatSearchResult(filteredChats));
    }
  }

  // 🔍 Clear search and show all chats
  void clearSearch() {
    currentSearchQuery = '';
    if (allChats != null) {
      filteredChats = List.from(allChats!.data ?? []);
      emit(ChatListLoaded(ChatModelNEW(
        message: allChats!.message,
        data: filteredChats,
        success: allChats!.success,
      )));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
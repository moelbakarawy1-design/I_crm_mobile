import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';
import 'package:admin_app/featuer/chat/data/repo/chat_repo.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart'; 
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final MessagesRepository messagesRepository;
  final SocketService socketService; // ✅ Injected

  StreamSubscription? _messageSubscription; // ✅ Subscription handle

  ChatCubit(this.chatRepository, this.messagesRepository, this.socketService)
      : super(ChatInitial());

  ChatModelNEW? allChats;
  
  // Fetch all chats
  Future<void> fetchAllChats() async {
    emit(ChatLoading());
    try {
      final chatModel = await chatRepository.getAllChats();
      if (isClosed) return;
      allChats = chatModel;
      emit(ChatListLoaded(chatModel));
      
      _setupSocketListeners(); // ✅ Start listening after load
    } catch (e) {
      if (isClosed) return;
      emit(ChatError(e.toString()));
    }
  }

  // Assign chat
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

  // Rename chat
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

  // Delete chat
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

  // ---------------------------------------------------------------------------
  // 🔌 Socket Logic for Chat List
  // ---------------------------------------------------------------------------

  void _setupSocketListeners() async {
    // Ensure connected
    await socketService.connect();

    // Cancel existing to avoid duplicates
    _messageSubscription?.cancel();

    // Listen to the Broadcast Stream
    _messageSubscription = socketService.newMessageStream.listen((data) {
      _handleNewMessage(data);
    });
  }

  void _handleNewMessage(dynamic data) {
    if (isClosed || allChats?.data == null) return;

    try {
      // 1. Parse Data
      dynamic processedData = data;
      if (data is List && data.isNotEmpty) processedData = data[0];

      final jsonPayload = (processedData is Map && processedData.containsKey('data'))
          ? processedData['data']
          : processedData;

      final newMessage = OrderedMessages.fromJson(jsonPayload);
      final chatId = newMessage.chatId;

      // 2. Find the chat in the list
      final index = allChats!.data!.indexWhere((c) => c.id == chatId);

      if (index != -1) {
        // Chat exists: Update last message and move to top
        var chatToUpdate = allChats!.data![index];

        chatToUpdate.messages ??= [];
        chatToUpdate.messages!.add(Messages(
          id: newMessage.id,
          content: newMessage.content,
          timestamp: newMessage.timestamp,
          type: newMessage.type,
        ));

        // Remove from current position and insert at top (0)
        allChats!.data!.removeAt(index);
        allChats!.data!.insert(0, chatToUpdate);

        // Emit new state to refresh UI
        emit(ChatListLoaded(ChatModelNEW(
          message: allChats!.message,
          data: List.from(allChats!.data!),
        )));
      } else {
        // New chat found (not in list), refresh whole list
        fetchAllChats();
      }
    } catch (e) {
      print("❌ Error updating Chat List UI: $e");
    }
  }

  @override
  Future<void> close() {
    // ✅ Stop listening to updates, but DO NOT disconnect the socket
    _messageSubscription?.cancel();
    return super.close();
  }
}
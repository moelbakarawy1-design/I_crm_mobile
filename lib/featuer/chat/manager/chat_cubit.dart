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
  final SocketService socketService = SocketService();

  ChatCubit(this.chatRepository, this.messagesRepository)
      : super(ChatInitial());

  ChatModelNEW? allChats;
  // CHANGED: List<MessageData> -> List<OrderedMessages>
  List<OrderedMessages> currentMessages = [];
  String? currentChatId;

  //  تحميل جميع المحادثات
  Future<void> fetchAllChats() async {
    emit(ChatLoading());
    try {
      final chatModel = await chatRepository.getAllChats();
      if (isClosed) return;
      allChats = chatModel;
      emit(ChatListLoaded(chatModel));
      _setupSocketListeners(); // ✅ نربط السوكت بعد تحميل الشات
    } catch (e) {
      if (isClosed) return;
      emit(ChatError(e.toString()));
    }
  }

  //  تحميل رسائل محادثة معينة
  Future<void> loadMessages(String chatId) async {
    if (isClosed) return;
    emit(MessagesLoading());
    currentChatId = chatId;
    try {
      // Expecting response to be ChatMessagesModel
      final response = await messagesRepository.getMessages(chatId);
      
      // CHANGED: Access nested orderedMessages
      currentMessages = response.data?.orderedMessages ?? [];
      
      if (isClosed) return;
      emit(MessagesLoaded(currentMessages));
    } catch (e) {
      if (isClosed) return;
      emit(MessagesError(e.toString()));
    }
  }

  //  إرسال رسالة جديدة
  Future<void> sendMessage(String chatId, String message) async {
    try {
      final newMsgResponse = await messagesRepository.sendMessage(chatId, message);
      
      // Handle response based on your API structure (Assuming it returns Map or Model)
      // We parse it into OrderedMessages
      final msgData = newMsgResponse['data'];

      // Ensure we treat it as a single object or list
      final OrderedMessages newMessage;
       if (msgData is List && msgData.isNotEmpty) {
        newMessage = OrderedMessages.fromJson(msgData[0]);
      } else if (msgData is Map<String, dynamic>) {
        newMessage = OrderedMessages.fromJson(msgData);
      } else {
         // Fallback if data structure is exact match
         newMessage = OrderedMessages.fromJson(newMsgResponse);
      }

      currentMessages.add(newMessage);
      emit(MessagesLoaded(List.from(currentMessages)));

      await socketService.sendMessage(chatId, message);
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  //  حذف محادثة
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

  //  ربط socket event listeners
  void _setupSocketListeners() async {
    final connected = await socketService.connect();
    if (!connected) {
      print("❌ Socket connection failed");
      return;
    }

    socketService.socket?.onAny((event, data) {
      print('📡 [SOCKET] $event => $data');
    });

    socketService.onNewMessage(_handleNewMessage);
    socketService.onMessageStatusUpdated(_handleStatusUpdate);
  }

//  Handle New Message & Update List Real-Time
  void _handleNewMessage(dynamic data) {
    if (isClosed) return;

    try {
      // 1. Parse Data
      dynamic processedData = data;
      if (data is List && data.isNotEmpty) processedData = data[0];

      final jsonPayload = (processedData is Map && processedData.containsKey('data'))
          ? processedData['data']
          : processedData;

      // CHANGED: MessageData -> OrderedMessages
      final newMessage = OrderedMessages.fromJson(jsonPayload);
      final chatId = newMessage.chatId;

      // Inside the Chat Screen (Update Messages)
      if (chatId == currentChatId) {
        final exists = currentMessages.any((msg) => msg.id == newMessage.id);
        if (!exists) {
          currentMessages.add(newMessage);
          emit(MessagesLoaded(List.from(currentMessages))); // Update Chat Screen
        }
      }

      //  Chat List Screen (Update Preview & Order)
      if (allChats?.data != null) {
        final index = allChats!.data!.indexWhere((c) => c.id == chatId);

        if (index != -1) {
          // 1. Extract the chat that received the message
          var chatToUpdate = allChats!.data![index];

          // 2. Update its last message safely
          chatToUpdate.messages ??= [];
          
          // Note: Assuming 'Messages' class in ChatModelNEW is different from OrderedMessages
          // We map the fields manually here to match the Chat List model
          chatToUpdate.messages!.add(Messages(
            id: newMessage.id,
            content: newMessage.content,
            timestamp: newMessage.timestamp,
            type: newMessage.type, // Ensure type is updated for UI icon
          ));

          // 3. Move this chat to the TOP of the list (Visual Feedback)
          allChats!.data!.removeAt(index);
          allChats!.data!.insert(0, chatToUpdate);

          final updatedList = ChatModelNEW(
            message: allChats!.message,
            data: List.from(allChats!.data!), // Create copy of list
          );

          allChats = updatedList;
          emit(ChatListLoaded(updatedList));
        } else {
          fetchAllChats();
        }
      }

    } catch (e) {
      print("❌ Error updating real-time UI: $e");
    }
  }

  //  تحديث حالة الرسالة
  void _handleStatusUpdate(dynamic data) {
    if (isClosed) return;
    try {
      final msgId = data['waMessageId'];
      final newStatus = data['status'];
      final chatId = data['chatId'];

      if (chatId == currentChatId) {
        final index =
            currentMessages.indexWhere((msg) => msg.waMessageId == msgId);
        if (index != -1) {
          currentMessages[index].status = newStatus;
          if (isClosed) return;
          emit(MessagesLoaded(List.from(currentMessages)));
        }
      }
    } catch (e) {
      print("⚠️ Error updating message status: $e");
    }
  }

// ✅ [NEW] Assign chat function
  Future<void> assignChat(String chatId, String userId) async {
    emit(ChatActionLoading()); // Show modal spinner
    try {
      final response = await chatRepository.assignChat(chatId, userId);
      if (response.status == true) {
        emit(ChatActionSuccess(response.message));
        await fetchAllChats(); // Refresh the list
      } else {
        emit(ChatActionError(response.message)); // Show error snackbar
      }
    } catch (e) {
      emit(ChatActionError(e.toString()));
    }
  }

  // ✅ [NEW] Rename chat function
  Future<void> renameChat(String chatId, String newName) async {
    emit(ChatActionLoading()); // Show modal spinner
    try {
      final response = await chatRepository.renameChat(chatId, newName);
      if (response.status == true) {
        emit(ChatActionSuccess(response.message));
        await fetchAllChats(); // Refresh the list to show new name
      } else {
        emit(ChatActionError(response.message)); // Show error snackbar
      }
    } catch (e) {
      emit(ChatActionError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    socketService.disconnect();
    return super.close();
  }
}
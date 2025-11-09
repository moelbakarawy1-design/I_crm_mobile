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
  List<MessageData> currentMessages = [];
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
      final response = await messagesRepository.getMessages(chatId);
      currentMessages = response.data ?? [];
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
      final newMsgData = await messagesRepository.sendMessage(chatId, message);
      final newMessage =
          MessageData.fromJson(newMsgData['data'] ?? newMsgData);

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

  //  عند استقبال رسالة جديدة
  void _handleNewMessage(dynamic data) {
    if (isClosed) return;
    try {
      final newMessage = MessageData.fromJson(data['data'] ?? data);
      final chatId = newMessage.chatId;
      if (chatId == null) return;

      //  لو المستخدم فاتح نفس المحادثة، ضيفها مباشرة
      if (chatId == currentChatId) {
        currentMessages.add(newMessage);
        if (isClosed) return;
        emit(MessagesLoaded(List.from(currentMessages)));
      }

      //  حدث آخر رسالة في قائمة المحادثات
      if (allChats?.data != null) {
        final index = allChats!.data!.indexWhere((c) => c.id == chatId);
        if (index != -1) {
          allChats!.data![index].messages ??= [];
          allChats!.data![index].messages!.add(Messages(
            id: newMessage.id,
            content: newMessage.content,
            timestamp: newMessage.timestamp,
          ));
        }
        if (isClosed) return;
        emit(ChatListLoaded(allChats!));
      }

      print(" New message handled successfully");
    } catch (e) {
      print(" Error handling new message: $e");
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

  @override
  Future<void> close() {
    socketService.disconnect();
    return super.close();
  }
}

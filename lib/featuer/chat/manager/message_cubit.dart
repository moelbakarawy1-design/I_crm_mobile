// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';

/// --- STATES ---
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<OrderedMessages> messages;
  MessagesLoaded(this.messages);
}

class MessagesError extends MessagesState {
  final String error;
  MessagesError(this.error);
}

/// --- CUBIT ---
class MessagesCubit extends Cubit<MessagesState> {
  final MessagesRepository messagesRepository;
  final SocketService socketService; // ✅ Injected

  List<OrderedMessages> allMessages = [];
  final Set<String> _messageIds = {};

  String? _currentChatId;
  String? _savedNextCursor; // الكيرسر الحالي
  bool _hasNextPage = true;
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  // ✅ Subscriptions
  StreamSubscription? _msgSubscription;
  StreamSubscription? _statusSubscription;

  MessagesCubit(this.messagesRepository, this.socketService)
    : super(MessagesInitial());

  /// Helper: Use Direct URL from Message
  /// السيرفر بيبعت الرابط كامل في content، مش محتاجين نبنيه
  OrderedMessages _fixMessageUrl(OrderedMessages msg) {
    // نرجع الرسالة زي ما هي لأن content فيه الرابط الكامل من السيرفر
    return msg;
  }

  void _sortMessages() {
    allMessages.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.now();
      DateTime dateB = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.now();
      return dateB.compareTo(dateA);
    });
  }

  void _addOrUpdateMessage(OrderedMessages newMessage) {
    if (isClosed) return;

    final index = allMessages.indexWhere((msg) => msg.id == newMessage.id);

    if (index != -1) {
      // تحديث رسالة موجودة
      allMessages[index] = newMessage;
    } else {
      // إضافة رسالة جديدة
      // 👇 التعديل: نتأكد إنها مش في الـ Set ونضيفها
      if (!_messageIds.contains(newMessage.id)) {
        allMessages.add(newMessage);
        _messageIds.add(newMessage.id!); // ✅ ضيف الـ ID هنا
      }
    }

    _sortMessages(); // ✅ نعيد الترتيب احتياطي
    emit(MessagesLoaded(List.from(allMessages)));
  }

  void _addUniqueMessages(List<OrderedMessages> newMessages) {
    for (var msg in newMessages) {
      if (!_messageIds.contains(msg.id)) {
        _messageIds.add(msg.id!);
        allMessages.add(_fixMessageUrl(msg));
      }
    }
    _sortMessages();
  }

  Future<void> getMessages(String chatId) async {
    if (isClosed) return;
    emit(MessagesLoading());
    _currentChatId = chatId;

    _savedNextCursor = null;
    _hasNextPage = true;
    allMessages.clear();
    _messageIds.clear();

    try {
      await socketService.connect();
      socketService.joinChat(chatId);
      _listenForSocketEvents();

      final response = await messagesRepository.getMessages(chatId);

      _savedNextCursor = response.data?.nextCursor;
      _hasNextPage = response.data?.hasNextPage ?? false;

      if (response.data?.orderedMessages != null) {
        _addUniqueMessages(response.data!.orderedMessages!);
      }

      emit(MessagesLoaded(List.from(allMessages)));
    } catch (e) {
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  // داخل MessagesCubit.dart

  Future<void> loadMoreMessages() async {
    // نفس شروط الحماية القديمة
    if (!_hasNextPage || _isLoadingMore || _savedNextCursor == null) return;

    _isLoadingMore = true;
    print("⏳ Requesting Batch of 20 with Cursor: $_savedNextCursor");

    try {
      final response = await messagesRepository.getMessages(
        _currentChatId!,
        cursor: _savedNextCursor,
        // الـ limit بقى مبعوت جوه الـ Repo تلقائي
      );

      _savedNextCursor = response.data?.nextCursor;
      _hasNextPage = response.data?.hasNextPage ?? false;

      final incomingMessages = response.data?.orderedMessages ?? [];

      print(
        "📦 Received Batch Size: ${incomingMessages.length}",
      ); // لوج عشان نتأكد

      if (incomingMessages.isNotEmpty) {
        int oldLength = allMessages.length;
        _addUniqueMessages(incomingMessages);

        if (allMessages.length > oldLength) {
          if (!isClosed) emit(MessagesLoaded(List.from(allMessages)));
        }

        // 👇👇 التعديل الجديد (شرط التوقف الإضافي)
        // لو طلبنا 20 وجالنا أقل من 20، يبقى أكيد دي آخر صفحة حتى لو الباك إند قال غير كده
        if (incomingMessages.length < 20) {
          _hasNextPage = false;
          print("🛑 Reached end of messages (Batch < 20)");
        }
      } else {
        // لو القائمة فاضية يبقى خلصنا
        _hasNextPage = false;
      }
    } catch (e) {
      print("❌ Error loading more: $e");
    } finally {
      // الـ Delay مهم عشان الـ List تلحق تطول قبل ما السكرول يحس تاني
      await Future.delayed(const Duration(milliseconds: 200));
      _isLoadingMore = false;
    }
  }

  /// 🎧 Listen to Socket Streams
  void _listenForSocketEvents() {
    // Clear old subs
    _msgSubscription?.cancel();
    _statusSubscription?.cancel();

    // New Message Listener
    _msgSubscription = socketService.newMessageStream.listen((data) {
      _handleNewMessage(data);
    });

    // Status Update Listener
    _statusSubscription = socketService.messageStatusStream.listen((data) {
      _handleStatusUpdate(data);
    });
  }

  void _handleNewMessage(dynamic data) {
    if (isClosed) return;
    try {
      var newMessage = OrderedMessages.fromJson(data['data'] ?? data);

      // Only add if it belongs to THIS chat
      if (newMessage.chatId != _currentChatId) return;

      newMessage = _fixMessageUrl(newMessage);
      _addOrUpdateMessage(newMessage);
    } catch (e) {
      print('⚠️ Error parsing socket message: $e');
    }
  }

  void _handleStatusUpdate(dynamic data) {
    if (isClosed) return;
    try {
      final msgIdToUpdate = data['waMessageId'];
      final newStatus = data['status'];
      final chatOfMessage = data['chatId'];

      if (chatOfMessage != null && chatOfMessage != _currentChatId) return;

      final index = allMessages.indexWhere(
        (msg) => msg.waMessageId == msgIdToUpdate,
      );
      if (index != -1) {
        allMessages[index].status = newStatus;
        emit(MessagesLoaded(List.from(allMessages)));
      }
    } catch (e) {
      print('⚠️ Error updating status: $e');
    }
  }

  /// 📤 Send Text
  Future<void> sendMessage(String chatId, String message) async {
    if (message.trim().isEmpty) return;
    try {
      // API Call
      final newMsgResponse = await messagesRepository.sendMessage(
        chatId,
        message,
      );
      final msgData = (newMsgResponse['data'] ?? newMsgResponse);
      final newMessage = OrderedMessages.fromJson(msgData);

      _addOrUpdateMessage(newMessage); // Update UI immediately

      // Socket Emit
      await socketService.sendMessage(chatId, message);
    } catch (e) {
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  /// 📤 Send Media (Generic)
  Future<void> _sendMediaMessage(
    String chatId,
    String path,
    String type,
    String caption,
  ) async {
    if (path.isEmpty) return;
    try {
      Map<String, dynamic> newMsgData;

      if (type == 'image') {
        newMsgData = await messagesRepository.sendImageMessage(
          chatId,
          path,
          caption,
        );
      } else if (type == 'video')
        newMsgData = await messagesRepository.sendVideoMessage(
          chatId,
          path,
          caption,
        );
      else if (type == 'file')
        newMsgData = await messagesRepository.sendDocumentMessage(chatId, path);
      else if (type == 'audio')
        newMsgData = await messagesRepository.sendAudioMessage(chatId, path);
      else
        return;

      final messageJson = newMsgData['data'] ?? newMsgData;
      var newMessage = OrderedMessages.fromJson(messageJson);
      newMessage = _fixMessageUrl(newMessage);
      newMessage.type = type == 'file' ? 'file' : type;

      _addOrUpdateMessage(newMessage);
    } catch (e) {
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  Future<void> createChat(String phone, String name) async {
    if (isClosed) return;

    emit(MessagesLoading());

    try {
      final response = await messagesRepository.createChat(phone, name);

      if (response != null && response.status) {
        emit(MessagesLoaded([]));
      } else {
        emit(MessagesError("Failed to create chat"));
      }
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }

  Future<void> sendLocationMessage(
    String chatId,
    double lat,
    double long,
  ) async {
    try {
      print('📍 Sending Location...');
      final newMsgData = await messagesRepository.sendLocationMessage(
        chatId,
        lat,
        long,
      );

      final messageJson = newMsgData['data'] ?? newMsgData;

      // CHANGED: MessageData -> OrderedMessages

      final newMessage = OrderedMessages.fromJson(messageJson);
      newMessage.type = 'location';
      _addOrUpdateMessage(newMessage); // ✅ Use helper
    } catch (e) {
      print('❌ Error sending location: $e');

      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  Future<void> sendContactMessage(
    String chatId,
    String name,
    String phone,
  ) async {
    try {
      print('👤 Sending Contact...');

      final newMsgData = await messagesRepository.sendContactMessage(
        chatId,
        name,
        phone,
      );
      final messageJson = newMsgData['data'] ?? newMsgData;
      // CHANGED: MessageData -> OrderedMessages
      final newMessage = OrderedMessages.fromJson(messageJson);

      _addOrUpdateMessage(newMessage); // ✅ Use helper
    } catch (e) {
      print('❌ Error sending contact: $e');
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  // Wrappers
  Future<void> sendImageMessage(String chatId, String path, String caption) =>
      _sendMediaMessage(chatId, path, 'image', caption);
  Future<void> sendVideoMessage(String chatId, String path, String caption) =>
      _sendMediaMessage(chatId, path, 'video', caption);
  Future<void> sendDocumentMessage(String chatId, String path) =>
      _sendMediaMessage(chatId, path, 'file', '');
  Future<void> sendAudioMessage(String chatId, String path) =>
      _sendMediaMessage(chatId, path, 'audio', '');

  @override
  Future<void> close() {
    _msgSubscription?.cancel();
    _statusSubscription?.cancel();

    if (_currentChatId != null) {
      socketService.leaveChat(_currentChatId!);
    }

    return super.close();
  }
}

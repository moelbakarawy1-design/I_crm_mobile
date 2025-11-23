import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart';

/// --- STATES ---
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  // CHANGED: MessageData -> OrderedMessages
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
  final SocketService socketService = SocketService();

  // CHANGED: List<MessageData> -> List<OrderedMessages>
  List<OrderedMessages> allMessages = [];
  String? _currentChatId;

  MessagesCubit(this.messagesRepository) : super(MessagesInitial());

  /// ✅ HELPER: Convert Media IDs to Full URLs
  // CHANGED: MessageData -> OrderedMessages
  OrderedMessages _fixMessageUrl(OrderedMessages msg) {
    if (msg.content == null) return msg;
    if (['image', 'video', 'audio', 'file', 'document'].contains(msg.type)) {
      final content = msg.content.toString();
      if (content.isNotEmpty && !content.startsWith('http') && !content.startsWith('/')) {
        msg.content = '${EndPoints.baseUrl}/chats/media/$content';
      }
    }
    return msg;
  }

  /// ✅ HELPER: Centralized Message Adding (Prevents Duplicates)
  // CHANGED: MessageData -> OrderedMessages
  void _addOrUpdateMessage(OrderedMessages newMessage) {
    if (isClosed) return;

    // 1. Check if message already exists by ID
    final index = allMessages.indexWhere((msg) => msg.id == newMessage.id);

    if (index != -1) {
      // 🔄 UPDATE existing message (Socket might have arrived before API response)
      allMessages[index] = newMessage;
      print('🔄 Message updated: ${newMessage.id}');
    } else {
      // ➕ ADD new message
      allMessages.add(newMessage);
      print('➕ Message added: ${newMessage.id}');
    }

    // 2. Emit new state
    emit(MessagesLoaded(List.from(allMessages)));
  }

  /// --- Load messages ---
  Future<void> getMessages(String chatId) async {
    if (isClosed) return;
    emit(MessagesLoading());
    _currentChatId = chatId;

    try {
      final connected = await socketService.connect();
      if (!connected) print('❌ Socket connection failed.');

      socketService.socket?.emit('join_chat', {'chatId': _currentChatId});
      listenForSocketEvents();

      // Response is ChatMessagesModel
      final response = await messagesRepository.getMessages(chatId);
      
      // CHANGED: digging into .data?.orderedMessages
      allMessages = (response.data?.orderedMessages ?? [])
          .map((msg) => _fixMessageUrl(msg))
          .toList();
          
      if (!isClosed) emit(MessagesLoaded(List.from(allMessages)));

    } catch (e) {
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  /// --- Send Text Message ---
  Future<void> sendMessage(String chatId, String message) async {
    if (message.trim().isEmpty) return;
    
    try {
      final newMsgResponse = await messagesRepository.sendMessage(chatId, message);
      
      // Check structure (Handle wrapping if necessary)
      final msgData = (newMsgResponse['data'] ?? newMsgResponse);
      
      // CHANGED: MessageData -> OrderedMessages
      final newMessage = OrderedMessages.fromJson(msgData);
      
      _addOrUpdateMessage(newMessage); // ✅ Use helper

      await socketService.sendMessage(chatId, message);

    } catch (e) {
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  // -----------------------------------------------------------------------------
  // 📤 Unified Media Sending
  // -----------------------------------------------------------------------------

  Future<void> sendImageMessage(String chatId, String path, String caption) async => 
      _sendMediaMessage(chatId, path, 'image', caption);

  Future<void> sendVideoMessage(String chatId, String path, String caption) async => 
      _sendMediaMessage(chatId, path, 'video', caption);

  Future<void> sendDocumentMessage(String chatId, String path) async => 
      _sendMediaMessage(chatId, path, 'file', '');

  Future<void> sendAudioMessage(String chatId, String path) async => 
      _sendMediaMessage(chatId, path, 'audio', '');

  Future<void> _sendMediaMessage(String chatId, String path, String type, String caption) async {
    if (path.isEmpty) return;

    try {
      print('🚀 Sending $type...');
      Map<String, dynamic> newMsgData;

      if (type == 'image') {
        newMsgData = await messagesRepository.sendImageMessage(chatId, path, caption);
      } else if (type == 'video') {
        newMsgData = await messagesRepository.sendVideoMessage(chatId, path, caption);
      } else if (type == 'file') {
        newMsgData = await messagesRepository.sendDocumentMessage(chatId, path);
      } else if (type == 'audio') {
        newMsgData = await messagesRepository.sendAudioMessage(chatId, path);
      } else {
        return;
      }

      final messageJson = newMsgData['data'] ?? newMsgData;
      // CHANGED: MessageData -> OrderedMessages
      var newMessage = OrderedMessages.fromJson(messageJson);

      // ✅ Fix URL and Force Type
      newMessage = _fixMessageUrl(newMessage);
      newMessage.type = type == 'file' ? 'file' : type; // Ensure consistency

      // ✅ Use helper to prevent duplicates
      _addOrUpdateMessage(newMessage);

      print('✅ $type sent locally');

    } catch (e) {
      print('❌ Error sending $type: $e');
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  // 👤 Send Contact
  Future<void> sendContactMessage(String chatId, String name, String phone) async {
    try {
      print('👤 Sending Contact...');

      final newMsgData = await messagesRepository.sendContactMessage(chatId, name, phone);
      final messageJson = newMsgData['data'] ?? newMsgData;
      // CHANGED: MessageData -> OrderedMessages
      final newMessage = OrderedMessages.fromJson(messageJson);

      _addOrUpdateMessage(newMessage); // ✅ Use helper

    } catch (e) {
      print('❌ Error sending contact: $e');
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  // 📍 Send Location
  Future<void> sendLocationMessage(String chatId, double lat, double long) async {
    try {
      print('📍 Sending Location...');

      final newMsgData = await messagesRepository.sendLocationMessage(chatId, lat, long);
      final messageJson = newMsgData['data'] ?? newMsgData;
      // CHANGED: MessageData -> OrderedMessages
      final newMessage = OrderedMessages.fromJson(messageJson);
      
      // Force type location if server misses it
      newMessage.type = 'location'; 

      _addOrUpdateMessage(newMessage); // ✅ Use helper

    } catch (e) {
      print('❌ Error sending location: $e');
      if (!isClosed) emit(MessagesError(e.toString()));
    }
  }

  // -----------------------------------------------------------------------------
  // 🔌 Socket Listeners
  // -----------------------------------------------------------------------------

  void listenForSocketEvents() {
    socketService.socket?.off('newMessage');
    socketService.socket?.off('messageStatusUpdated');
    
    socketService.onNewMessage(_handleNewMessage);
    socketService.onMessageStatusUpdated(_handleStatusUpdate);
  }

  void _handleNewMessage(dynamic data) {
    if (isClosed) return;
    print('📥 [SOCKET] New message received: $data');
    try {
      // CHANGED: MessageData -> OrderedMessages
      var newMessage = OrderedMessages.fromJson(data['data'] ?? data);

      if (newMessage.chatId != _currentChatId) return;

      newMessage = _fixMessageUrl(newMessage);

      // ✅ Use helper to prevent duplicates from socket
      _addOrUpdateMessage(newMessage);
      
    } catch (e) {
      print('⚠️ Error parsing new message: $e');
    }
  }

  void _handleStatusUpdate(dynamic data) {
    if (isClosed) return;
    try {
      final msgIdToUpdate = data['waMessageId']; 
      final newStatus = data['status'];
      final chatOfMessage = data['chatId'];

      if (chatOfMessage != null && chatOfMessage != _currentChatId) return;

      final index = allMessages.indexWhere((msg) => msg.waMessageId == msgIdToUpdate);

      if (index != -1) {
        allMessages[index].status = newStatus;
        emit(MessagesLoaded(List.from(allMessages))); 
      }
    } catch (e) {
      print(' Error updating status: $e');
    }
  }

  Future<void> createChat(String phone ,String name) async {
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

  @override
  Future<void> close() {
    socketService.disconnect();
    return super.close();
  }
}
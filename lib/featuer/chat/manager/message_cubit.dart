import 'dart:async';
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
  String? _currentChatId;

  // ✅ Subscriptions
  StreamSubscription? _msgSubscription;
  StreamSubscription? _statusSubscription;

  MessagesCubit(this.messagesRepository, this.socketService) : super(MessagesInitial());

  /// Helper: Fix Media URLs
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

  /// Helper: Add/Update Message safely
  void _addOrUpdateMessage(OrderedMessages newMessage) {
    if (isClosed) return;
    
    final index = allMessages.indexWhere((msg) => msg.id == newMessage.id);

    if (index != -1) {
      allMessages[index] = newMessage; // Update
    } else {
      allMessages.add(newMessage); // Add
    }
    emit(MessagesLoaded(List.from(allMessages)));
  }

  /// 📥 Load Messages & Setup Socket
  Future<void> getMessages(String chatId) async {
    if (isClosed) return;
    emit(MessagesLoading());
    _currentChatId = chatId;

    try {
      // 1. Ensure Socket Connection & Join Room
      await socketService.connect();
      socketService.joinChat(chatId);
      
      // 2. Start Listening
      _listenForSocketEvents();

      // 3. Fetch API History
      final response = await messagesRepository.getMessages(chatId);
      
      allMessages = (response.data?.orderedMessages ?? [])
          .map((msg) => _fixMessageUrl(msg))
          .toList();
          
      if (!isClosed) emit(MessagesLoaded(List.from(allMessages)));

    } catch (e) {
      if (!isClosed) emit(MessagesError(e.toString()));
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

      final index = allMessages.indexWhere((msg) => msg.waMessageId == msgIdToUpdate);
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
      final newMsgResponse = await messagesRepository.sendMessage(chatId, message);
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
  Future<void> _sendMediaMessage(String chatId, String path, String type, String caption) async {
    if (path.isEmpty) return;
    try {
      Map<String, dynamic> newMsgData;
      
      if (type == 'image') newMsgData = await messagesRepository.sendImageMessage(chatId, path, caption);
      else if (type == 'video') newMsgData = await messagesRepository.sendVideoMessage(chatId, path, caption);
      else if (type == 'file') newMsgData = await messagesRepository.sendDocumentMessage(chatId, path);
      else if (type == 'audio') newMsgData = await messagesRepository.sendAudioMessage(chatId, path);
      else return;

      final messageJson = newMsgData['data'] ?? newMsgData;
      var newMessage = OrderedMessages.fromJson(messageJson);
      newMessage = _fixMessageUrl(newMessage);
      newMessage.type = type == 'file' ? 'file' : type;

      _addOrUpdateMessage(newMessage);

    } catch (e) {
      if (!isClosed) emit(MessagesError(e.toString()));
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

  } Future<void> sendLocationMessage(String chatId, double lat, double long) async {

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
  // Wrappers
  Future<void> sendImageMessage(String chatId, String path, String caption) => _sendMediaMessage(chatId, path, 'image', caption);
  Future<void> sendVideoMessage(String chatId, String path, String caption) => _sendMediaMessage(chatId, path, 'video', caption);
  Future<void> sendDocumentMessage(String chatId, String path) => _sendMediaMessage(chatId, path, 'file', '');
  Future<void> sendAudioMessage(String chatId, String path) => _sendMediaMessage(chatId, path, 'audio', '');

  @override
  Future<void> close() {
    // 1. Cancel Listeners for this screen
    _msgSubscription?.cancel();
    _statusSubscription?.cancel();
    
    // 2. Tell Server we left this room
    if (_currentChatId != null) {
      socketService.leaveChat(_currentChatId!);
    }
    
    // 3. DO NOT disconnect the socket (ChatCubit needs it)
    return super.close();
  }
}
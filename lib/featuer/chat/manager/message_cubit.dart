import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/data/repo/MessagesRepository.dart';
import 'package:admin_app/featuer/chat/service/Socetserver.dart'; // ✅ Make sure this path is correct

/// --- STATES ---
abstract class MessagesState {}

class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<MessageData> messages;
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

  List<MessageData> allMessages = [];
  String? _currentChatId; 

  MessagesCubit(this.messagesRepository) : super(MessagesInitial());

  /// --- Load existing messages + setup socket listeners ---
 Future<void> getMessages(String chatId) async {
  emit(MessagesLoading());
  _currentChatId = chatId;

  try {
    // ✅ Connect to socket first
    final connected = await socketService.connect();
    if (!connected) {
      print('❌ Socket connection failed.');
      return;
    }

    // ✅ Join chat room before fetching messages
    socketService.socket?.emit('join_chat', {'chatId': _currentChatId});
    print('📡 Joined chat room: $_currentChatId');

    // ✅ Listen for socket events early
    listenForSocketEvents();

    // 📨 Fetch existing messages
    final response = await messagesRepository.getMessages(chatId);
    allMessages = response.data ?? [];
    emit(MessagesLoaded(List.from(allMessages)));

  } catch (e) {
    emit(MessagesError(e.toString()));
  }
}

Future<void> sendVideoMessage(String chatId, String videoPath, String caption) async {
    if (videoPath.isEmpty) return;
    try {
      print('🎥 Sending Video...');

      // Call Repo
      final newMsgData = await messagesRepository.sendVideoMessage(chatId, videoPath, caption);
      
      // Parse & Fix URL
      var newMessage = MessageData.fromJson(newMsgData['data'] ?? newMsgData);
      newMessage = _fixMessageUrl(newMessage); // 👈 مهم جداً عشان يظهر فالفيديجت فوراً

      // Update List
      allMessages.add(newMessage);

      // Socket
      await socketService.sendMessage(chatId, 'Video');

      // Emit State
      emit(MessagesLoaded(List.from(allMessages)));
      print('✅ Video sent successfully');

    } catch (e) {
      print('❌ Error sending video: $e');
      emit(MessagesError(e.toString()));
      emit(MessagesLoaded(List.from(allMessages)));
    }
  }
 MessageData _fixMessageUrl(MessageData msg) {
    if (msg.content == null) return msg;
    if (['image', 'video', 'audio', 'file', 'document'].contains(msg.type)) {
      final content = msg.content.toString();
      if (content.isNotEmpty && !content.startsWith('http') && !content.startsWith('/')) {
        msg.content = '${EndPoints.baseUrl}/chats/media/$content';
      }
    }
    return msg;
  }
  /// 3. دالة إرسال المستندات (منفصلة)
  Future<void> sendDocumentMessage(String chatId, String filePath) async {
    if (filePath.isEmpty) return;
    try {
      print('📄 Sending Document...');

      // Call Repo
      final newMsgData = await messagesRepository.sendDocumentMessage(chatId, filePath);
      
      // Parse & Fix URL
      var newMessage = MessageData.fromJson(newMsgData['data'] ?? newMsgData);
      newMessage = _fixMessageUrl(newMessage);

      // Update List
      allMessages.add(newMessage);

      // Socket
      await socketService.sendMessage(chatId, 'Attachment');

      // Emit State
      emit(MessagesLoaded(List.from(allMessages)));
      print('✅ Document sent successfully');

    } catch (e) {
      print('❌ Error sending document: $e');
      emit(MessagesError(e.toString()));
      emit(MessagesLoaded(List.from(allMessages)));
    }
  }
  /// --- Send a new message ---
 Future<void> sendMessage(String chatId, String message) async {
  if (message.trim().isEmpty) return;
  
  try {
    // 🔹 Add message locally (optional loading state)
    final newMsgData = await messagesRepository.sendMessage(chatId, message);
    final newMessage = MessageData.fromJson(newMsgData['data'] ?? newMsgData);

    final exists = allMessages.any((msg) => msg.id == newMessage.id);
    if (!exists) {
      allMessages.add(newMessage);
    }

    // ✅ Send over socket FIRST (so the event gets sent before UI updates)
    await socketService.sendMessage(chatId, message);

    // ✅ Then emit state (UI updates after socket emit)
    emit(MessagesLoaded(List.from(allMessages)));

  } catch (e) {
    emit(MessagesError(e.toString()));
    emit(MessagesLoaded(List.from(allMessages)));
  }
}
 Future<void> sendLocationMessage(String chatId, double lat, double long) async {
    try {
      print('📍 Sending Location...');

      // 1. Send to API
      final newMsgData = await messagesRepository.sendLocationMessage(chatId, lat, long);
      
      // 2. Parse Response
      final messageJson = newMsgData['data'] ?? newMsgData;
      final newMessage = MessageData.fromJson(messageJson);

      // 3. Add to local list
      final exists = allMessages.any((msg) => msg.id == newMessage.id);
      if (!exists) {
        allMessages.add(newMessage);
      }

      // 4. Notify Socket
      await socketService.sendMessage(chatId, 'Location');

      emit(MessagesLoaded(List.from(allMessages)));
      print('✅ Location sent successfully');

    } catch (e) {
      print('❌ Error sending location: $e');
      emit(MessagesError(e.toString()));
      emit(MessagesLoaded(List.from(allMessages)));
    }
  }
  /// --- Send audio message ---
  Future<void> sendAudioMessage(String chatId, String audioFilePath) async {
    if (audioFilePath.trim().isEmpty) return;
    
    try {
      print('🎤 Starting audio message send...');
      
      // 🔹 Send audio file
      final newMsgData = await messagesRepository.sendAudioMessage(chatId, audioFilePath);
      
      print('📦 Response data: $newMsgData');
      
      // Parse the response - handle both nested and flat structures
      final messageJson = newMsgData['data'] ?? newMsgData;
      final newMessage = MessageData.fromJson(messageJson);

      print('✅ Audio message created: ${newMessage.id}');

      final exists = allMessages.any((msg) => msg.id == newMessage.id);
      if (!exists) {
        allMessages.add(newMessage);
        print('✅ Message added to list');
      }

      // ✅ Send over socket
      await socketService.sendMessage(chatId, 'Audio message');

      // ✅ Then emit state (UI updates after socket emit)
      emit(MessagesLoaded(List.from(allMessages)));
      print('✅ State emitted with audio message');

    } catch (e) {
      print('❌ Audio message error: $e');
      emit(MessagesError(e.toString()));
      emit(MessagesLoaded(List.from(allMessages)));
    }
  }



  void listenForSocketEvents() {
    
    socketService.onNewMessage(_handleNewMessage);
    socketService.onReceiveMessage(_handleNewMessage);

    socketService.onMessageStatusUpdated(_handleStatusUpdate);
  }

  void _handleNewMessage(dynamic data) {
    print('📥 [SOCKET] New message received: $data');
    try {
      final newMessage = MessageData.fromJson(data['data'] ?? data);

      if (newMessage.chatId != _currentChatId) {
        print('🚫 Ignored message from another chat: ${newMessage.chatId}');
        return;
      }

      //  Add message if it's not already in the list
      final exists = allMessages.any((msg) => msg.id == newMessage.id);
      if (!exists) {
        allMessages.add(newMessage);
        emit(MessagesLoaded(List.from(allMessages)));
        print('✅ Message added and UI updated.');
      }
    } catch (e) {
      print('⚠️ Error parsing new message: $e');
    }
  }

  //  Helper function to handle status updates
  void _handleStatusUpdate(dynamic data) {
    print('🔄 [SOCKET] Message status updated: $data');
    try {
      
      final msgIdToUpdate = data['waMessageId']; 
      final newStatus = data['status'];
      final chatOfMessage = data['chatId'];

      
      if (chatOfMessage != null && chatOfMessage != _currentChatId) {
        print('🚫 Ignored status update from another chat: $chatOfMessage');
        return;
      }

      final index = allMessages.indexWhere((msg) => msg.waMessageId == msgIdToUpdate);

      if (index != -1) {
        allMessages[index].status = newStatus;
        emit(MessagesLoaded(List.from(allMessages))); 
        print(' Message status updated in UI.');
      } else {
        
         print(' Message with waMessageId $msgIdToUpdate not found in list.');
      }
    } catch (e) {
      print(' Error updating message status: $e');
    }
  }

  /// --- Create new chat ---
  Future<void> createChat(String phone ,String name) async {
    emit(MessagesLoading());
    try {
      final response = await messagesRepository.createChat(phone, name);
      if (response != null && response.status) {
        print(' Chat created: ${response.data}');
        emit(MessagesLoaded([])); 
      } else {
        emit(MessagesError("Failed to create chat"));
      }
    } catch (e) {
      emit(MessagesError(e.toString()));
    }
  }
// In MessagesCubit.dart

Future<void> sendImageMessage(String chatId, String imagePath, String caption) async {
  if (imagePath.isEmpty) return;

  try {
    print('📸 Starting image upload...');

    // 1. Send to API
    final newMsgData = await messagesRepository.sendImageMessage(chatId, imagePath, caption);
    
    // 2. Parse Response
    final messageJson = newMsgData['data'] ?? newMsgData;
    final newMessage = MessageData.fromJson(messageJson);

    // 3. Add to local list immediately
    final exists = allMessages.any((msg) => msg.id == newMessage.id);
    if (!exists) {
      allMessages.add(newMessage);
    }

    // 4. Notify Socket (so other user sees "Image" in chat list)
    await socketService.sendMessage(chatId, 'Image');

    // 5. Update UI
    emit(MessagesLoaded(List.from(allMessages)));
    print('✅ Image sent and UI updated');

  } catch (e) {
    print('❌ Image message error: $e');
    emit(MessagesError(e.toString()));
    // Restore list if needed
    emit(MessagesLoaded(List.from(allMessages)));
  }
  
}
  /// --- Cleanup ---
  @override
  Future<void> close() {
    print(' Disconnecting socket from cubit...');
    socketService.disconnect();
    return super.close();
  }
}
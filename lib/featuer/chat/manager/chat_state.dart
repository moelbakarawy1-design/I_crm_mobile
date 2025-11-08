import 'package:admin_app/featuer/chat/data/model/ChatMessagesModel.dart';
import 'package:admin_app/featuer/chat/data/model/chat_model12.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

// قائمة المحادثات
class ChatListLoaded extends ChatState {
  final ChatModelNEW chatModel;
  ChatListLoaded(this.chatModel);
}

// تحميل الرسائل
class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<MessageData> messages;
  MessagesLoaded(this.messages);
}

class MessagesError extends ChatState {
  final String error;
  MessagesError(this.error);
}

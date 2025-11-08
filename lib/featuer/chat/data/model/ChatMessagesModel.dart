class ChatMessagesModel {
  bool? success;
  String? message;
  List<MessageData>? data;

  ChatMessagesModel({this.success, this.message, this.data});

  ChatMessagesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MessageData>[];
      json['data'].forEach((v) {
        data!.add(MessageData.fromJson(v));
      });
    }
  }
}

class MessageData {
  String? id;
  String? waMessageId;
  String? chatId;
  String? content;
  String? senderType;
  String? direction;
  String? timestamp;
  String? from;
  String? to;
  String? status;

  MessageData({
    this.id,
    this.chatId,
    this.waMessageId,
    this.content,
    this.senderType,
    this.direction,
    this.timestamp,
    this.from,
    this.to,
    this.status,
  });

  MessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    waMessageId = json['waMessageId']; 
    chatId = json['chatId'];
    content = json['content'];
    senderType = json['senderType'];
    direction = json['direction'];
    timestamp = json['timestamp'];
    from = json['from'];
    to = json['to'];
    status = json['status'];
  }
}

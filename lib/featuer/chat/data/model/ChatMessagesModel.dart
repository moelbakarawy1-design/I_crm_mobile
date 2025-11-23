class ChatMessagesModel {
  bool? success;
  String? message;
  Data? data;

  ChatMessagesModel({this.success, this.message, this.data});

  ChatMessagesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<OrderedMessages>? orderedMessages;
  bool? hasNextPage;
  String? nextCursor;

  Data({this.orderedMessages, this.hasNextPage, this.nextCursor});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['orderedMessages'] != null) {
      orderedMessages = <OrderedMessages>[];
      json['orderedMessages'].forEach((v) {
        orderedMessages!.add(OrderedMessages.fromJson(v));
      });
    }
    hasNextPage = json['hasNextPage'];
    nextCursor = json['nextCursor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderedMessages != null) {
      data['orderedMessages'] =
          orderedMessages!.map((v) => v.toJson()).toList();
    }
    data['hasNextPage'] = hasNextPage;
    data['nextCursor'] = nextCursor;
    return data;
  }
}

class OrderedMessages {
  String? id;
  String? waMessageId;
  String? chatId;
  String? createdAt;
  String? timestamp;
  String? status;
  String? type;
  String? senderType;
  String? direction;
  String? from;
  String? to;
  String? content;
  String? caption;

  OrderedMessages(
      {this.id,
      this.waMessageId,
      this.chatId,
      this.createdAt,
      this.timestamp,
      this.status,
      this.type,
      this.senderType,
      this.direction,
      this.from,
      this.to,
      this.content,
      this.caption});

  OrderedMessages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    waMessageId = json['waMessageId'];
    chatId = json['chatId'];
    createdAt = json['createdAt'];
    timestamp = json['timestamp'];
    status = json['status'];
    type = json['type'];
    senderType = json['senderType'];
    direction = json['direction'];
    from = json['from'];
    to = json['to'];
    content = json['content'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['waMessageId'] = waMessageId;
    data['chatId'] = chatId;
    data['createdAt'] = createdAt;
    data['timestamp'] = timestamp;
    data['status'] = status;
    data['type'] = type;
    data['senderType'] = senderType;
    data['direction'] = direction;
    data['from'] = from;
    data['to'] = to;
    data['content'] = content;
    data['caption'] = caption;
    return data;
  }
}

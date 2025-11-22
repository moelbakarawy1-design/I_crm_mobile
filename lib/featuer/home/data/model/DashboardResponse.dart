class DashboardResponse {
  bool? success;
  String? message;
  DashboardData? data;

  DashboardResponse({this.success, this.message, this.data});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
  }
}

class DashboardData {
  Counts? counts;
  List<ChatPerUser>? chatsPerUser;
  List<LatestChat>? latestChats;
  List<MessageStat>? messageStats;

  DashboardData({this.counts, this.chatsPerUser, this.latestChats, this.messageStats});

  DashboardData.fromJson(Map<String, dynamic> json) {
    counts = json['counts'] != null ? Counts.fromJson(json['counts']) : null;
    if (json['chatsPerUser'] != null) {
      chatsPerUser = <ChatPerUser>[];
      json['chatsPerUser'].forEach((v) {
        chatsPerUser!.add(ChatPerUser.fromJson(v));
      });
    }
    if (json['latestChats'] != null) {
      latestChats = <LatestChat>[];
      json['latestChats'].forEach((v) {
        latestChats!.add(LatestChat.fromJson(v));
      });
    }
    if (json['messageStats'] != null) {
      messageStats = <MessageStat>[];
      json['messageStats'].forEach((v) {
        messageStats!.add(MessageStat.fromJson(v));
      });
    }
  }
}

class Counts {
  int? users;
  int? customers;
  int? chats;

  Counts({this.users, this.customers, this.chats});

  Counts.fromJson(Map<String, dynamic> json) {
    users = json['users'];
    customers = json['customers'];
    chats = json['chats'];
  }
}

class ChatPerUser {
  String? userId;
  String? name;
  int? chatsCount;

  ChatPerUser({this.userId, this.name, this.chatsCount});

  ChatPerUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    chatsCount = json['chatsCount'];
  }
}

class LatestChat {
  String? chatId;
  Customer? customer;
  AssignedTo? assignedTo;
  String? createdAt;

  LatestChat({this.chatId, this.customer, this.assignedTo, this.createdAt});

  LatestChat.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    assignedTo = json['assignedTo'] != null ? AssignedTo.fromJson(json['assignedTo']) : null;
    createdAt = json['createdAt'];
  }
}

class Customer {
  String? name;
  String? phone;

  Customer({this.name, this.phone});

  Customer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
  }
}

class AssignedTo {
  String? name;

  AssignedTo({this.name});

  AssignedTo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}

class MessageStat {
  String? type;
  int? count;

  MessageStat({this.type, this.count});

  MessageStat.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    count = json['count'];
  }
}
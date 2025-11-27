class ChatModelNEW {
  bool? success;
  String? message;
  List<Data>? data;

  ChatModelNEW({this.success, this.message, this.data});

  ChatModelNEW.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? createdAt;
  Customer? customer;
  User? user;
  List<Messages>? messages;

  Data({this.id, this.createdAt, this.customer, this.user, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Customer {
  String? id;
  String? name;
  String? phone;

  Customer({this.id, this.name, this.phone});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}

class User {
  String? name;
  String? id;

  User({this.name, this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

class Messages {
  String? id;
  String? content;
  String? timestamp;
  String? type; 
  String? caption; 

  Messages({
    this.id, 
    this.content, 
    this.timestamp, 
    this.type, 
    this.caption,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    timestamp = json['timestamp'];
    type = json['type']; 
    caption = json['caption']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['timestamp'] = timestamp;
    data['type'] = type;
    data['caption'] = caption;
    return data;
  }
}
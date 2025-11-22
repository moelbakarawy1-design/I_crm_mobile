class ProfileUser {
  bool? success;
  String? message;
  Data? data;

  ProfileUser({this.success, this.message, this.data});

  ProfileUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
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
  String? id;
  String? email;
  String? name;
  String? magicToken;
  String? magicTokenExpiry;
  String? password;
  String? resetCode;
  String? codeExpiry;
  Null verificationToken;
  String? resendCodeToken;
  String? roleId;
  String? createdAt;
  String? lastPasswordChange;
  String? lastLogout;
  String? lastResetCodeSentAt;
  Role? role;

  Data(
      {this.id,
      this.email,
      this.name,
      this.magicToken,
      this.magicTokenExpiry,
      this.password,
      this.resetCode,
      this.codeExpiry,
      this.verificationToken,
      this.resendCodeToken,
      this.roleId,
      this.createdAt,
      this.lastPasswordChange,
      this.lastLogout,
      this.lastResetCodeSentAt,
      this.role});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    magicToken = json['magicToken'];
    magicTokenExpiry = json['magicTokenExpiry'];
    password = json['password'];
    resetCode = json['resetCode'];
    codeExpiry = json['codeExpiry'];
    verificationToken = json['verificationToken'];
    resendCodeToken = json['resendCodeToken'];
    roleId = json['roleId'];
    createdAt = json['createdAt'];
    lastPasswordChange = json['lastPasswordChange'];
    lastLogout = json['lastLogout'];
    lastResetCodeSentAt = json['lastResetCodeSentAt'];
    role = json['role'] != null ?  Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['magicToken'] = magicToken;
    data['magicTokenExpiry'] = magicTokenExpiry;
    data['password'] = password;
    data['resetCode'] = resetCode;
    data['codeExpiry'] = codeExpiry;
    data['verificationToken'] = verificationToken;
    data['resendCodeToken'] = resendCodeToken;
    data['roleId'] = roleId;
    data['createdAt'] = createdAt;
    data['lastPasswordChange'] = lastPasswordChange;
    data['lastLogout'] = lastLogout;
    data['lastResetCodeSentAt'] = lastResetCodeSentAt;
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}

class Role {
  String? id;
  String? name;
  List<String>? permissions;

  Role({this.id, this.name, this.permissions});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    permissions = json['permissions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['permissions'] = permissions;
    return data;
  }
}
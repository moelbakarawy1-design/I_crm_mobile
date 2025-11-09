class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String status;
  final String message;
  final String? token;
  final String? refreshToken;
  final UserModel? user;

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    this.refreshToken,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? 'fail',
      message: json['message'] ?? '',
      token: json['token'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String? email;
  final UserRoleModel? role; // ✅ change to object instead of String

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] != null ? UserRoleModel.fromJson(json['role']) : null,
    );
  }
}

class UserRoleModel {
  final String name;
  final List<String> permissions;

  UserRoleModel({required this.name, required this.permissions});

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      name: json['name'] ?? '',
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : [],
    );
  }
}

class ForgetPasswordRequest {
  final String email;

  ForgetPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

// --- FIXED ---
// Updated to match your Postman response
class ForgetPasswordResponse {
  final String status;
  final String message;
  final String? resendCodeToken; // Added this field

  ForgetPasswordResponse({
    required this.status,
    required this.message,
    this.resendCodeToken,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      status: json['status'] ?? 'fail', // Changed from 'success' (bool)
      message: json['message'] ?? '',
      resendCodeToken: json['resendCodeToken'], // Added this
    );
  }
}
// --- END FIX ---

class VerifyOtpRequest {
  final String code;

  VerifyOtpRequest({
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }
}

// This is the VerifyOtpResponse you provided.
class VerifyOtpResponse {
  final bool success; 
  final String message;
  final String? token;
  final String? refreshToken;

  VerifyOtpResponse(
      {required this.success,
      required this.message,
      this.token,
      this.refreshToken});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}

class ResetPasswordRequest {
  final String token;
  final String password;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.token,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

class ResetPasswordResponse {
  final bool success;
  final String message;

  ResetPasswordResponse({
    required this.success,
    required this.message,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

// cahnge password
class ChangePasswordRequest {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirm;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'newPasswordConfirm': newPasswordConfirm,
    };
  }
}
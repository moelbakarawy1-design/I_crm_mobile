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
  final bool success;
  final String message;
  final String? token;
  final AdminData? admin;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.admin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      admin: json['admin'] != null ? AdminData.fromJson(json['admin']) : null,
    );
  }
}

class AdminData {
  final String id;
  final String email;
  final String name;
  final String? role;

  AdminData({
    required this.id,
    required this.email,
    required this.name,
    this.role,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'],
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

class ForgetPasswordResponse {
  final bool success;
  final String message;

  ForgetPasswordResponse({
    required this.success,
    required this.message,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class VerifyOtpRequest {
  final String email;
  final String code;

  VerifyOtpRequest({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
    };
  }
}

class VerifyOtpResponse {
  final bool success;
  final String message;
  final String? token;

  VerifyOtpResponse({
    required this.success,
    required this.message,
    this.token,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
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

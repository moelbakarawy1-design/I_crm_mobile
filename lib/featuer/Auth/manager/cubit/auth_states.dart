import 'package:admin_app/featuer/Auth/data/model/auth_models.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// Login States
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String message;
  final AdminData? admin;

  LoginSuccess({
    required this.message,
    this.admin,
  });
}

class LoginError extends AuthState {
  final String message;

  LoginError({required this.message});
}

// Forget Password States
class ForgetPasswordLoading extends AuthState {}

class ForgetPasswordSuccess extends AuthState {
  final String message;

  ForgetPasswordSuccess({required this.message});
}

class ForgetPasswordError extends AuthState {
  final String message;

  ForgetPasswordError({required this.message});
}

// Verify OTP States
class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {
  final String message;
  final String? token;

  VerifyOtpSuccess({
    required this.message,
    this.token,
  });
}

class VerifyOtpError extends AuthState {
  final String message;

  VerifyOtpError({required this.message});
}

// Reset Password States
class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final String message;

  ResetPasswordSuccess({required this.message});
}

class ResetPasswordError extends AuthState {
  final String message;

  ResetPasswordError({required this.message});
}

// General States
class AuthLogout extends AuthState {}

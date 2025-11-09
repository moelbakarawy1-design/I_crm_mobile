import 'package:admin_app/featuer/Auth/data/model/auth_models.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

// Login States
class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String message;
  final UserModel? user;

  LoginSuccess({required this.message, this.user});
}

class LoginError extends AuthState {
  final String message;

  LoginError({required this.message});
}

// Forget Password States
class ForgetPasswordLoading extends AuthState {}

// --- FIXED ---
// Added resendCodeToken
class ForgetPasswordSuccess extends AuthState {
  final String message;
  final String? resendCodeToken;

  ForgetPasswordSuccess({required this.message, this.resendCodeToken});
}
// --- END FIX ---

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


class ChangePasswordLoading extends AuthState {}

class ChangePasswordSuccess extends AuthState {}

class ChangePasswordFailure extends AuthState {
  final String errorMessage;
  ChangePasswordFailure(this.errorMessage);
}
// Add these to your AuthState file

// --- Logout All States ---
class LogoutAllLoading extends AuthState {}

class LogoutAllSuccess extends AuthState {}

class LogoutAllFailure extends AuthState {
  final String errorMessage;
  LogoutAllFailure(this.errorMessage);
}

class LogoutLoading extends AuthState {}

class LogoutSuccess extends AuthState {}

class LogoutFailure extends AuthState {
  final String errorMessage;
  LogoutFailure(this.errorMessage);
}
class ResendOtpLoading extends AuthState {}

class ResendOtpSuccess extends AuthState {
  final String message;
  ResendOtpSuccess({required this.message});
}

class ResendOtpError extends AuthState {
  final String message;
  ResendOtpError({required this.message});
}

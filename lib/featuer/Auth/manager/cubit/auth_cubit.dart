import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/Auth/data/model/auth_models.dart';
import 'package:admin_app/featuer/Auth/data/repository/auth_repository.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  // Login
  Future<void> login({
  required String email,
  required String password,
}) async {
  emit(LoginLoading());

  try {
    final request = LoginRequest(email: email, password: password);
    final response = await _authRepository.login(request);

    if (response.status) {
      final loginData = LoginResponse.fromJson(response.data);
      emit(LoginSuccess(
        message: loginData.message,
        admin: loginData.admin,
      ));
    } else {
      emit(LoginError(message: response.message));
    }
  } catch (e) {
    emit(LoginError(message: 'حدث خطأ غير متوقع'));
  }
}


  // Forget Password
  Future<void> forgetPassword({
    required String email,
  }) async {
    emit(ForgetPasswordLoading());

    try {
      final request = ForgetPasswordRequest(email: email);

      final response = await _authRepository.forgetPassword(request);

      if (response.status) {
        final forgetData = ForgetPasswordResponse.fromJson(response.data);
        emit(ForgetPasswordSuccess(message: forgetData.message));
      } else {
        emit(ForgetPasswordError(message: response.message));
      }
    } catch (e) {
      emit(ForgetPasswordError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // Verify OTP
  Future<void> verifyOtp({
    required String email,
    required String code,
  }) async {
    emit(VerifyOtpLoading());

    try {
      final request = VerifyOtpRequest(
        email: email,
        code: code,
      );

      final response = await _authRepository.verifyOtp(request);

      if (response.status) {
        final otpData = VerifyOtpResponse.fromJson(response.data);
        emit(VerifyOtpSuccess(
          message: otpData.message,
          token: otpData.token,
        ));
      } else {
        emit(VerifyOtpError(message: response.message));
      }
    } catch (e) {
      emit(VerifyOtpError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // Reset Password
  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());

    try {
      final request = ResetPasswordRequest(
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      );

      final response = await _authRepository.resetPassword(request);

      if (response.status) {
        final resetData = ResetPasswordResponse.fromJson(response.data);
        emit(ResetPasswordSuccess(message: resetData.message));
      } else {
        emit(ResetPasswordError(message: response.message));
      }
    } catch (e) {
      emit(ResetPasswordError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // Logout
 Future<void> logout() async {
  await _authRepository.logout(); // this will clear SharedPreferences
  emit(AuthLogout());
}



}

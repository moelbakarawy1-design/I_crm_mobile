import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Auth/data/model/User_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_app/featuer/Auth/data/model/auth_models.dart';
import 'package:admin_app/featuer/Auth/data/repository/auth_repository.dart';
import 'package:admin_app/featuer/Auth/manager/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  // Login
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      final request = LoginRequest(email: email, password: password);
      final loginData = await _authRepository.login(request);
      List<String> apiPermissions = [];
      if (loginData.user?.role?.permissions != null) {
        apiPermissions = loginData.user!.role!.permissions
            .map((permission) => permission.name)
            .toList();
      }

      print("📥 Login Success. Saving ${apiPermissions.length} permissions...");

      // 2. Save User Data & Permissions
      await LocalData.saveUserData(
        userId: loginData.user?.id ?? '',
        userName: loginData.user?.name ?? '',
        userEmail: email,
        userRole: loginData.user?.role?.name ?? '',
        permissions: apiPermissions,
      );

      // 3. Save Tokens
      await LocalData.saveTokens(
        accessToken: loginData.token ?? '',
        refreshToken: loginData.refreshToken,
      );

      emit(LoginSuccess(message: loginData.message, user: loginData.user));
    } catch (e) {
      print("Login Error: $e");
      emit(LoginError(message: e.toString()));
    }
  }

  Future<void> forgetPassword({required String email}) async {
    emit(ForgetPasswordLoading());
    try {
      final request = ForgetPasswordRequest(email: email);
      final response = await _authRepository.forgetPassword(request);
      emit(
        ForgetPasswordSuccess(
          message: response.message,
          resendCodeToken: response.resendCodeToken,
        ),
      );
    } catch (e) {
      emit(ForgetPasswordError(message: e.toString()));
    }
  }

  // Verify OTP
  Future<void> verifyOtp({required String code}) async {
    emit(VerifyOtpLoading());
    try {
      final otpData = await _authRepository.verifyOtp(code: code);

      final token = otpData['token'] as String?;
      final message = otpData['message'] as String? ?? '';

      if (token == null) {
        throw Exception("Verification token is missing!");
      }

      emit(VerifyOtpSuccess(message: message, token: token));
    } catch (e) {
      emit(VerifyOtpError(message: e.toString()));
    }
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final message = await _authRepository.resetPassword(
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      );

      emit(ResetPasswordSuccess(message: message));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }

  // Get User Profile
  Future<void> getUserProfile() async {
    emit(GetProfileLoading());
    try {
      final Data user = await _authRepository.getUserProfile();

      // 🔄 Sync fetched profile data with LocalData
      // This ensures role/permissions are updated everywhere when profile refreshes
      if (user.role != null && user.role!.permissions != null) {
        await LocalData.updateRoleAndPermissions(
          userRole: user.role!.name ?? '',
          permissions: user.role!.permissions!,
        );
        print('✅ [AuthCubit] Synced profile data with LocalData');
        print('   Role: ${user.role!.name}');
        print('   Permissions: ${user.role!.permissions!.length}');
      }

      emit(GetProfileSuccess(user: user));
    } catch (e) {
      emit(GetProfileError(message: e.toString()));
    }
  }

  Future<void> resendOtp({required String resendCodeToken}) async {
    emit(ResendOtpLoading());
    try {
      final message = await _authRepository.resendOtp(
        resendCodeToken: resendCodeToken,
      );
      emit(ResendOtpSuccess(message: message));
    } catch (e) {
      print('$e');
      emit(ResendOtpError(message: e.toString()));
    }
  }

  // Change Password
  Future<void> changePassword(ChangePasswordRequest request) async {
    emit(ChangePasswordLoading());
    try {
      // Repository will throw an error if it fails
      await _authRepository.changePassword(request);
      emit(ChangePasswordSuccess());

      // ✅ FIX: Log user out on SUCCESS
      await _authRepository.logout();
      await LocalData.clear(); // Clear local storage
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }

  // Logout
  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      await _authRepository.logout();
      await LocalData.clear(); // Clear local storage
      emit(LogoutSuccess());
    } catch (e) {
      await LocalData.clear(); // Ensure clear happens even if API fails
      emit(LogoutSuccess());
    }
  }

  // Logout All Devices
  Future<void> logoutAllDevices() async {
    emit(LogoutAllLoading());
    try {
      await _authRepository.logoutAllDevices();
      // ✅ FIX: Call the main logout function to clear all local data/cookies
      await _authRepository.logout();
      await LocalData.clear();
      emit(LogoutAllSuccess());
    } catch (e) {
      emit(LogoutAllFailure(e.toString()));
    }
  }

  Future<void> notAdminLogIn(String email) async {
    emit(NotAdminLogInLoading());
    try {
      final response = await _authRepository.notAdminLogIn(email);
      emit(NotAdminLogInSuccess(message: response.message));
    } catch (e) {
      emit(NotAdminLogInError(message: e.toString()));
    }
  }

  Future<void> createAdmin({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(CreateAdminLoading());
    try {
      final request = CreateAdminRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );

      final response = await _authRepository.createAdmin(request);

      emit(
        CreateAdminSuccess(message: response.message, adminData: response.data),
      );
    } catch (e) {
      emit(CreateAdminError(message: e.toString()));
    }
  }
}

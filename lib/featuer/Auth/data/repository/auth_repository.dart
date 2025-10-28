import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Auth/data/model/auth_models.dart';

class AuthRepository {
  final APIHelper _apiHelper = APIHelper();

  // Login
  Future<ApiResponse> login(LoginRequest request) async {
    final response = await _apiHelper.postRequest(
      endPoint: EndPoints.adminLogin,
      data: request.toJson(),
      isFormData: false,
      isAuthorized: false,
    );

    // Save token if login successful
    if (response.status && response.data != null) {
  final loginData = LoginResponse.fromJson(response.data);
  if (loginData.token != null) {
    await LocalData.saveTokens(accessToken: loginData.token!,
    refreshToken: loginData.refreshToken, 
    );
  }
  
}
    return response;
  }

  // Forget Password
  Future<ApiResponse> forgetPassword(ForgetPasswordRequest request) async {
    return await _apiHelper.postRequest(
      endPoint: EndPoints.adminForgetPassword,
      data: request.toJson(),
      isFormData: false,
      isAuthorized: false,
    );
  }

  // Verify OTP
  Future<ApiResponse> verifyOtp(VerifyOtpRequest request) async {
    final response = await _apiHelper.postRequest(
      endPoint: EndPoints.adminverfiyCode,
      data: request.toJson(),
      isFormData: false,
      isAuthorized: false,
    );

    // Save token if verification successful
   if (response.status && response.data != null) {
  final otpData = VerifyOtpResponse.fromJson(response.data);
  if (otpData.token != null) {
    await LocalData.saveTokens(accessToken: otpData.token!, refreshToken:otpData.refreshToken );
  }
}


    return response;
  }

  // Reset Password
  Future<ApiResponse> resetPassword(ResetPasswordRequest request) async {
    final endPoint = EndPoints.adminresetPassword.replaceAll(':token', request.token);
    
    return await _apiHelper.postRequest(
      endPoint: endPoint,
      data: request.toJson(),
      isFormData: false,
      isAuthorized: false,
    );
  }
  Future<bool> refreshToken() async {
    final String? currentRefreshToken = LocalData.refreshToken;

    // If no refresh token exists, we can't refresh.
    if (currentRefreshToken == null) {
      return false;
    }

    try {
      final response = await _apiHelper.postRequest(
        endPoint: EndPoints.refreshToken, 
        data: {'refreshToken': currentRefreshToken},
        isFormData: false, 
        isAuthorized: false, 
      );

      // If refresh was successful
      if (response.status && response.data != null) {
        // Assume your refresh response returns new tokens
        // e.g., { "accessToken": "...", "refreshToken": "..." }
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        // Save the new tokens
        await LocalData.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return true; // Success!
      } else {
        // Refresh failed (e.g., refresh token expired)
        await logout(); // Log the user out
        return false;
      }
    } catch (e) {
      // Any error during refresh means we should log out
      await logout();
      return false;
    }
  }
  // Logout
  Future<void> logout() async {
  await LocalData.clear();
}

}

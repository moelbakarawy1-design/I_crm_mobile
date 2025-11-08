import 'package:admin_app/core/network/api_helper.dart';
import 'package:admin_app/core/network/api_endpoiont.dart';
import 'package:admin_app/core/network/api_response.dart';
import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Auth/data/model/auth_models.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final APIHelper _apiHelper = APIHelper();

  // Login
Future<LoginResponse> login(LoginRequest request) async {
  final response = await _apiHelper.postRequest(
    endPoint: EndPoints.adminLogin,
    data: request.toJson(),
    isFormData: false,
    isAuthorized: false,
  );

  if (response.status && response.data != null) {
    final loginData = LoginResponse.fromJson(response.data);

    if (loginData.status == 'success') {
      final data = response.data['data'] ?? {};

      final accessToken = data['accessToken'] ?? loginData.token;
      final refreshToken = data['refreshToken'] ?? loginData.refreshToken;

      if (accessToken == null || refreshToken == null) {
        throw Exception('Login failed: Tokens not provided by API.');
      }

      // ✅ Save tokens correctly
      await LocalData.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      // ✅ Save user data
      if (loginData.user != null) {
        await LocalData.saveUserData(
          userId: loginData.user!.id,
          userName: loginData.user!.name,
          userEmail: loginData.user!.email ?? '',
          userRole: loginData.user!.role?.name ?? 'unknown',
        );
      }

      print('✅ Login successful. Tokens saved successfully.');
      return loginData;
    } else {
      throw Exception(loginData.message);
    }
  } else {
    // ❌ Handle failure case
    String errorMessage = "Login failed. Please try again.";

    if (response.message is Map) {
      final mapMsg = response.message as Map<String, dynamic>;
      errorMessage = mapMsg.values
          .expand((v) => v is List ? v : [v])
          .join('\n');
    } else {
      errorMessage = response.message;
    }
  

    throw Exception(errorMessage);
  }
}



  // Forget Password
 Future<String> forgetPassword(ForgetPasswordRequest request) async {
    final response = await _apiHelper.postRequest(
      endPoint: EndPoints.adminForgetPassword,
      data: request.toJson(),
      isFormData: false,
      isAuthorized: false,
    );

    if (response.status && response.data != null) {
      final forgetData = ForgetPasswordResponse.fromJson(response.data);
      if (forgetData.success) {
        return forgetData.message;
      } else {
        throw Exception(forgetData.message);
      }
    } else {
      throw Exception(response.message);
    }
  }

  // Reset Password
  Future<String> resetPassword(ResetPasswordRequest request) async {
    final endPoint =
        EndPoints.adminresetPassword.replaceAll(':token', request.token);

    final response = await _apiHelper.postRequest(
      endPoint: endPoint,
      data: request.toJson(),
      isFormData: false,
      isAuthorized: false,
    );

    if (response.status && response.data != null) {
      final resetData = ResetPasswordResponse.fromJson(response.data);
      if (resetData.success) {
        return resetData.message;
      } else {
        throw Exception(resetData.message);
      }
    } else {
      throw Exception(response.message);
    }
  }

  // Change Password
  Future<ApiResponse> changePassword(ChangePasswordRequest request) async {
    return await _apiHelper.postRequest(
      endPoint: EndPoints.changepassword,
      data: request.toJson(),
      isFormData: false,
      isAuthorized: true,
    );
  }

  // Logout
 Future<void> logout() async {
  try {
    final String? accessToken = LocalData.accessToken;
    final String? refreshToken = LocalData.refreshToken;

    if (accessToken == null || refreshToken == null) {
      print("⚠️ Missing tokens — skipping API logout.");
      await LocalData.clear();
      return;
    }

    print("🔹 Sending logout request with both tokens...");

    final dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));

    final response = await dio.post(
      EndPoints.logout,
      data: {'refreshToken': refreshToken},
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        validateStatus: (_) => true,
      ),
    );

    print("📥 Logout Response [${response.statusCode}]: ${response.data}");
  } catch (e) {
    print("❌ Logout request failed: $e");
  }

  await LocalData.clear();
  print("🧹 Local data cleared — logout completed.");
}
Future<bool> refreshToken() async {
  print("--- 1. Attempting to refresh token using saved RefreshToken... ---");

  final String? currentAccessToken = LocalData.accessToken;
  final String? currentRefreshToken = LocalData.refreshToken;

  if (currentRefreshToken == null || currentAccessToken == null) {
    print("--- 2. ❌ REFRESH FAILED: Missing tokens. ---");
    return false;
  }

  print("--- 2. Sending refresh token: $currentRefreshToken ---");

  try {
    final dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));

    final response = await dio.post(
      EndPoints.refreshToken,
      data: {'refreshToken': currentRefreshToken}, // 🔹 Refresh token in body
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $currentAccessToken', // 🔹 Access in header
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    print("--- 3. Refresh API Response Status: ${response.statusCode} ---");
    print("--- 3. Refresh API Response Data: ${response.data} ---");

    if (response.statusCode == 200 &&
        response.data != null &&
        (response.data['success'] == true ||
         response.data['status'] == 'success')) {
      
      final newAccessToken = response.data['data']?['accessToken'];
      final newRefreshToken = response.data['data']?['refreshToken'];

      if (newAccessToken != null && newRefreshToken != null) {
        await LocalData.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken, // ✅ Save new refresh token too
        );

        print("--- ✅ REFRESH SUCCESS: New tokens saved. ---");
        return true;
      } else {
        print("--- ❌ REFRESH FAILED: Missing token fields in response. ---");
      }
    } else {
      print("--- ❌ REFRESH FAILED: Invalid response structure. ---");
    }

    await logout();
    return false;
  } catch (e) {
    print("--- ❌ REFRESH FAILED: Exception occurred: $e ---");
    await logout();
    return false;
  }
}


Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest request) async {
    final response = await _apiHelper.postRequest(
      endPoint: EndPoints.adminverfiyCode,
      data: request.toJson(),
      isFormData: false,
      
    );

    if (response.status && response.data != null) {
      final otpData = VerifyOtpResponse.fromJson(response.data);
      if (otpData.success && otpData.token != null) {
        // Save tokens from OTP (this is important)
        await LocalData.saveTokens(
          accessToken: otpData.token!,
          refreshToken: otpData.refreshToken,
        );
        return otpData;
      } else {
        throw Exception(otpData.message);
      }
    } else {
      throw Exception(response.message);
    }
  }

  // Logout from all devices
  Future<ApiResponse> logoutAllDevices() async {
    final String? currentRefreshToken = LocalData.refreshToken;
    return await _apiHelper.postRequest(
      endPoint: EndPoints.logoutFromAll,
      isAuthorized: true,
     data: {'refreshToken': currentRefreshToken},
    );
  }
}
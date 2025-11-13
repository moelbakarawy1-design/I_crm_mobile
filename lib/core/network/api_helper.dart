import 'package:admin_app/core/network/local_data.dart';
import 'package:dio/dio.dart';
import 'api_endpoiont.dart';
import 'api_response.dart';

class APIHelper {
  static final APIHelper _apiHelper = APIHelper._internal();
  static bool _isInitialized = false;
  static late Dio _dioInstance;
  
  // We no longer need _isRefreshing, QueuedInterceptorsWrapper handles it

  factory APIHelper() {
    if (!_isInitialized) {
      throw Exception("APIHelper not initialized. Call APIHelper.init() first in your main.dart.");
    }
    return _apiHelper;
  }

  APIHelper._internal();

  static Future<void> init() async {
    if (_isInitialized) return;

    _dioInstance = Dio(BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));


   
    _dioInstance.interceptors.add(
      QueuedInterceptorsWrapper( 
        onError: (DioException err, handler) async {
  if (err.response?.statusCode == 401) {
    print('🔴 Interceptor caught 401 on: ${err.requestOptions.path}');

    // Prevent infinite loop on refresh endpoint
    if (err.requestOptions.path.contains(EndPoints.refreshToken)) {
      print('❌ Refresh endpoint itself failed (401). Logging out...');
      await LocalData.clear();
      return handler.reject(err);
    }

    print('🔄 Attempting token refresh...');

    try {
      final refreshToken = LocalData.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        print('⚠️ No stored refresh token — logging out.');
        await LocalData.clear();
        return handler.reject(err);
      }

      // Create a fresh Dio instance to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));

      final refreshResponse = await refreshDio.post(
        EndPoints.refreshToken,
        data: {'refreshToken': refreshToken}, // ✅ Correct body
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      print('📥 Refresh Response Status: ${refreshResponse.statusCode}');
      print('📥 Refresh Response Data: ${refreshResponse.data}');

      if (refreshResponse.statusCode == 200 &&
          refreshResponse.data['success'] == true &&
          refreshResponse.data['data'] != null &&
          refreshResponse.data['data']['accessToken'] != null) {
        final newAccessToken = refreshResponse.data['data']['accessToken'];
        final newRefreshToken = refreshResponse.data['data']['refreshToken'];

        // ✅ Save both tokens again
        await LocalData.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken ?? refreshToken,
        );

        print('✅ Token refreshed successfully! Retrying original request...');

        // Retry original request with updated token
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await _dioInstance.fetch(err.requestOptions);
        print('✅ Retried request success: ${retryResponse.statusCode}');
        return handler.resolve(retryResponse);
      } else {
        print('❌ Invalid refresh response. Logging out...');
        await LocalData.clear();
        return handler.reject(err);
      }
    } catch (refreshError) {
      print('❌ Refresh failed: $refreshError');
      await LocalData.clear();
      return handler.reject(err);
    }
  }

  // Not a 401 → continue error chain
  print('❌ Dio Error: ${err.type} - ${err.message}');
  return handler.next(err);
},

      ),
    );

    _isInitialized = true;
    print('✅ APIHelper initialized');
  }
  Dio get dio => _dioInstance;
  Future<ApiResponse> _handleRequest(
  Future<Response> Function() request, {
  required bool isProtected,
}) async {
  if (isProtected) {
    final token = LocalData.accessToken; // ✅ FIXED
    if (token == null || token.isEmpty) {
      print('❌ Request failed: No access token found for protected route');
      return ApiResponse(
        status: false,
        statusCode: 401,
        message: 'No access token found for protected route',
      );
    }
  }

  try {
    final response = await request();
    return ApiResponse.fromResponse(response);
  } catch (e) {
    print('❌ Request Error: $e');
    return ApiResponse.fromError(e);
  }
}


  Future<ApiResponse> getRequest({
    required String endPoint,
    String? resourcePath,
    Map<String, dynamic>? queryParameters,
    bool isProtected = true,
  }) async {
    return _handleRequest(isProtected: isProtected, () {
      final finalEndpoint = resourcePath != null && resourcePath.isNotEmpty
          ? '$endPoint/$resourcePath'
          : endPoint;
      
      return dio.get(
        finalEndpoint,
        queryParameters: queryParameters,
        options: Options(headers: {
          if (isProtected) "Authorization": "Bearer ${LocalData.accessToken}",
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );
    });
  }

  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    
    bool isFormData = true,
    bool isAuthorized = true, 
    Map<String, String>? extraHeaders,
  }) async {
    return _handleRequest(isProtected: isAuthorized, () {
      final headers = {
        if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}",
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
        if (extraHeaders != null) ...extraHeaders,
      };

      return dio.post(
        endPoint,
        data: isFormData && data != null ? FormData.fromMap(data) : data,
        options: Options(headers: headers),
      );
    });
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    return _handleRequest(isProtected: isAuthorized, () {
      return dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}",
          'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
        }),
      );
    });
  }

  Future<ApiResponse> patchRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = false,
    bool isAuthorized = true,
  }) async {
    return _handleRequest(isProtected: isAuthorized, () {
      print('PATCH 📤 Sending data: $data');
      return dio.patch(
        endPoint,
        data: isFormData && data != null ? FormData.fromMap(data) : data,
        options: Options(headers: {
          if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}",
          'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
        }),
      );
    });
  }

  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    return _handleRequest(isProtected: isAuthorized, () {
      return dio.delete(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}"
        }),
      );
    });
  }
}
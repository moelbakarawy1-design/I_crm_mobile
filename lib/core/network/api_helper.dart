import 'package:admin_app/core/network/local_data.dart';
import 'package:admin_app/featuer/Auth/data/repository/auth_repository.dart';
import 'package:dio/dio.dart';

import 'api_endpoiont.dart';
import 'api_response.dart';

class APIHelper {
  // singleton
  static final APIHelper _apiHelper = APIHelper._internal();

  factory APIHelper() {
    return _apiHelper;
  }

  // declaring dio
  late Dio dio; // Make dio non-final

  // --- CONSTRUCTOR ---
  APIHelper._internal() {
    // 1. Initialize Dio first
    dio = Dio(BaseOptions(
        baseUrl: EndPoints.baseUrl,
        connectTimeout: Duration(seconds: 20),
        sendTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20)));

    // 2. Add the interceptor to the initialized 'dio' instance
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          if (err.response?.statusCode == 401) {
            print('Access token expired. Attempting refresh...');

            // Use the correct endpoint variable name
            if (err.requestOptions.path == EndPoints.refreshToken) { // Assuming it's 'adminRefreshToken' from your previous example
              print('Refresh token request failed. Logging out.');
              await LocalData.clear();
              return handler.reject(err);
            }
            
            try {
              final authRepo = AuthRepository();
              final bool refreshSuccess = await authRepo.refreshToken();

              if (refreshSuccess) {
                print('✅ Token refresh successful. Retrying original request.');
                
                final options = err.requestOptions;
                options.headers['Authorization'] = 'Bearer ${LocalData.accessToken}';

                // 4. Retry the request with the new token
                final response = await dio.fetch(options);
                return handler.resolve(response); // Complete the request
              } else {
                print('❌ Token refresh failed. Rejecting request.');
                return handler.reject(err);
              }
            } catch (e) {
              print('❌ Exception during token refresh: $e');
              return handler.reject(err);
            }
          }
          // If not 401, just continue with the error
          return handler.next(err); 
        },
      ),
    );
  } // --- End of constructor ---

  // GET request
  Future<ApiResponse> getRequest({
    required String endPoint,
    String? resourcePath,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = true, // You use 'isProtected' here
    bool sendRefreshToken = false,
  }) async {
    try {
      final String finalEndpoint = resourcePath != null && resourcePath.isNotEmpty
          ? '$endPoint/$resourcePath'
          : endPoint;

      String? token = LocalData.accessToken;

      if (isProtected) {
        if (token == null || token.isEmpty) {
          throw Exception('No access token found');
        }
      }

      final response = await dio.get(
        finalEndpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            if (isProtected && token != null && token.isNotEmpty)
              "Authorization": "Bearer $token",
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 600;
          },
        ),
      );

      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  // PUT request
  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true, // You use 'isAuthorized' here
  }) async {
    try {
      var response = await dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          // Use the 'isAuthorized' parameter
          if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}" 
        }),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  // DELETE request
  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true, // 'isAuthorized'
  }) async {
    try {
      var response = await dio.delete(
        endPoint,
        data: isFormData ? FormData.fromMap(data ?? {}) : data,
        options: Options(headers: {
          if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}"
        }),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  // POST request
  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true, // 'isAuthorized'
  }) async {
    try {
      var response = await dio.post(
        endPoint,
        data: isFormData && data != null ? FormData.fromMap(data) : data,
        options: Options(
          headers: {
            if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}",
            'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
          },
        ),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }
  // PATCH request
  Future<ApiResponse> patchRequest({
    required String endPoint,
    Map<String, dynamic>? data, // Use consistent naming
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      print('PATCH 📤 Sending data: $data'); // Add logging
      
      var response = await dio.patch( // <-- Use dio.patch
        endPoint,
        data: isFormData && data != null ? FormData.fromMap(data) : data,
        options: Options(
          headers: {
            if (isAuthorized) "Authorization": "Bearer ${LocalData.accessToken}",
            'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
          },
        ),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      print('❌ PATCH Error: $e'); // Add specific error logging
      return ApiResponse.fromError(e);
    }
  }
}
import 'package:admin_app/core/network/local_data.dart';
import 'package:dio/dio.dart';

import 'api_endpoiont.dart';
import 'api_response.dart';

class APIHelper {
  // singleton
  static final APIHelper _apiHelper = APIHelper._internal();

  factory APIHelper() {
    return _apiHelper;
  }

  APIHelper._internal();

  // declaring dio
  Dio dio = Dio(BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: Duration(seconds: 20),
      sendTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20)));

  // GET request مبسط
Future<ApiResponse> getRequest({
  required String endPoint,
  String? resourcePath,
  Map<String, dynamic>? data,
  Map<String, dynamic>? queryParameters,
  bool isFormData = true,
  bool isProtected = true,
  bool sendRefreshToken = false,
}) async {
  try {
    final String finalEndpoint = resourcePath != null && resourcePath.isNotEmpty
        ? '$endPoint/$resourcePath'
        : endPoint;

    print('🌐 Full URL: ${dio.options.baseUrl}$finalEndpoint');
    print('🔐 Is Protected: $isProtected');

    String? token = LocalData.accessToken;

    // ✅ تحقق من وجود التوكن قبل الإرسال
    if (isProtected) {
      if (token == null || token.isEmpty) {
        print('⚠️ No access token found! Protected request canceled.');
        throw Exception('No access token found');
      } else {
        print('🔑 Using access token: $token');
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
          // ✅ نقبل أي كود حالة أقل من 600 لمعالجة الأخطاء في ApiResponse
          return status != null && status < 600;
        },
      ),
    );

    print('📥 Response Status: ${response.statusCode}');
    print('📥 Response Headers: ${response.headers}');
    print('📥 Response Data: ${response.data}');

    return ApiResponse.fromResponse(response);
  } catch (e) {
    print('❌ API Error: $e');
    return ApiResponse.fromError(e);
  }
}


  // PUT request
  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await dio.put(
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

  // DELETE request
  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
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
  Map<String, dynamic>? data, // Use consistent naming
  bool isFormData = true,
  bool isAuthorized = true,
}) async {
  try {
    print('📤 Sending data: $data'); // Add logging
    
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
    print('❌ POST Error: $e');
    return ApiResponse.fromError(e);
  }
}
}
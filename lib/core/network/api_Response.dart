import 'package:dio/dio.dart';

class ApiResponse {
  final bool status;
  final int statusCode;
  final dynamic data;
  final String message;

  ApiResponse({
    required this.status,
    required this.statusCode,
    this.data,
    required this.message,
  });

  // دالة لمعالجة استجابات Dio
  factory ApiResponse.fromResponse(Response response) {
    // التحقق من رمز الحالة أولاً
    final isHttpSuccess = response.statusCode != null && 
                         response.statusCode! >= 200 && 
                         response.statusCode! < 300;
    
    if (response.data is Map<String, dynamic>) {
      final dataMap = response.data as Map<String, dynamic>;
      
      // التصحيح: استخدام "success" بدلاً من "status"
      final bool apiSuccess = dataMap['success'] ?? isHttpSuccess;
      final String apiMessage = dataMap['message'] ?? 
                               (isHttpSuccess ? 'تمت العملية بنجاح' : 'فشلت العملية');
      
      // إرجاع الاستجابة كاملة
      final dynamic responseData = dataMap;
   
      return ApiResponse(
        status: apiSuccess,
        statusCode: response.statusCode ?? 500,
        data: responseData,
        message: apiMessage,
      );
    } else {
      // إذا كانت response.data ليست خريطة
      return ApiResponse(
        status: isHttpSuccess,
        statusCode: response.statusCode ?? 500,
        data: response.data,
        message: isHttpSuccess ? 'تمت العملية بنجاح' : 'فشلت العملية',
      );
    }
  }

  // دالة لمعالجة أخطاء Dio أو غيرها
  factory ApiResponse.fromError(dynamic error) {
    if (error is DioException) {
      return ApiResponse(
        status: false,
        data: error.response,
        statusCode: error.response != null ? error.response!.statusCode ?? 500 : 500,
        message: _handleDioError(error),
      );
    } else {
      return ApiResponse(
        status: false,
        statusCode: 500,
        message: 'حدث خطأ ما.',
      );
    }
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى.";
      case DioExceptionType.sendTimeout:
        return "انتهت مهلة الإرسال، يرجى التحقق من اتصال الإنترنت.";
      case DioExceptionType.receiveTimeout:
        return "انتهت مهلة الاستقبال، يرجى المحاولة مرة أخرى لاحقًا.";
      case DioExceptionType.badResponse:
        return _handleServerError(error.response);
      case DioExceptionType.cancel:
        return "تم إلغاء الطلب.";
      case DioExceptionType.connectionError:
        return "لا يوجد اتصال بالإنترنت.";
      default:
        return "حدث خطأ غير معروف.";
    }
  }

  /// معالجة الأخطاء من استجابة الخادم
  static String _handleServerError(Response? response) {
    if (response == null) return "لا توجد استجابة من الخادم.";
    if (response.data is Map<String, dynamic>) {
      return response.data["message"] ?? "حدث خطأ ما.";
    }
    return "خطأ في الخادم: ${response.statusMessage}";
  }
}
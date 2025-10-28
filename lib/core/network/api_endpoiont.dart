abstract class EndPoints {
  static const String baseUrl = 'http://192.168.1.4:5000/api';
  static const String adminLogin = '/auth/admin/login';
  static const String adminForgetPassword = '/auth/admin/forgetPassword';
  static const String adminverfiyCode = '/auth/admin/verifyCode';
  static const String adminresetPassword = '/auth/admin/resetPassword/:token';
  static const String getRoles = '/roles';
  static const String sendInvite = '/auth/invite';
  static const String refreshToken = '/auth/invite';
 

}
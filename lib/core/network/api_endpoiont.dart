abstract class EndPoints {
  static const String baseUrl = 'http://192.168.1.88:5000/api';
  static const String adminLogin = '/auth/admin/login';
  static const String adminForgetPassword = '/auth/admin/forgetPassword';
  static const String adminverfiyCode = '/auth/admin/verifyCode';
  static const String adminresetPassword = '/auth/admin/resetPassword/:token';
  static const String getRoles = '/roles';
  static const String sendInvite = '/auth/admin/invite';
  static const String refreshToken = '/auth/refresh';
  static const String changepassword = '/auth/admin/changePassword';
  static const String logout ='/auth/logout';
  static const String logoutFromAll ='/auth/logout-all';
  static const String getAllChat = '/chats';
  static const String getAllTask = '/tasks';
  static const String getAllUsers = '/users';
  static const String createTask = '/tasks';
  static const String resendOtp = '/auth/admin/resendCode';
  static const String notAdmin = '/auth/login';
  static const String assignChat = '/api/chats/assign';
  static const String renameUserChat = '/api/chats/name';
  static const String getProfile = '/users/me';
  static const String dashboard = '/dashboard';
  static String getMessagesByChatId(String chatId) => '/chats/$chatId/messages';
  static const socketUrl = 'http://192.168.1.88:5000';


}
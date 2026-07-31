class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleLogin = '/auth/google';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String fcmToken = '/auth/fcm-token';

  // Notifications
  static const String notifications = '/notifications';

  // Farm dashboard
  static const String farms = '/farms';
  static String farmDashboard(int farmId) => '/farms/$farmId/dashboard';
  static String farmAssistant(int farmId) => '/farms/$farmId/assistant/query';

  // Devices
  static const String devices = '/devices';
  static const String controls = '/controls';
  static String deviceControls(int deviceId) => '/devices/$deviceId/controls';
  static String deviceUsers(int deviceId) => '/devices/$deviceId/users';
}

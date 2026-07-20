class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleLogin = '/auth/google';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Notifications
  static const String notifications = '/notifications';

  // Devices
  static const String devices = '/devices';
  static String deviceControl(int deviceId) => '/devices/$deviceId/control';
  static String deviceHistory(int deviceId) => '/devices/$deviceId/history';
  static String deviceAccess(int deviceId) => '/devices/$deviceId/access';
}

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

  // Devices
  static const String devices = '/devices';
  static const String controls = '/controls';
  static String deviceControls(int deviceId) => '/devices/$deviceId/controls';
  static String deviceUsers(int deviceId) => '/devices/$deviceId/users';

  // Farms
  static const String farms = '/farms';
  static String farm(int farmId) => '/farms/$farmId';
  static String farmDashboard(int farmId) => '/farms/$farmId/dashboard';
  static String farmTasks(int farmId) => '/farms/$farmId/tasks';
  static String farmTask(int farmId, int taskId) =>
      '/farms/$farmId/tasks/$taskId';
  static String farmTelemetry(int farmId) => '/farms/$farmId/telemetry';
  static String farmLatestTelemetry(int farmId) =>
      '/farms/$farmId/telemetry/latest';
  static String farmIrrigation(int farmId) => '/farms/$farmId/irrigation';
  static String farmUsage(int farmId) => '/farms/$farmId/usage';
  static String farmRipeness(int farmId) => '/farms/$farmId/ripeness';
  static String ripenessResult(int farmId, int resultId) =>
      '/farms/$farmId/ripeness/$resultId';
  static String farmLogs(int farmId) => '/farms/$farmId/logs';
  static String farmLog(int farmId, int logId) => '/farms/$farmId/logs/$logId';
  static String farmHarvests(int farmId) => '/farms/$farmId/harvests';
  static String farmAssistant(int farmId) => '/farms/$farmId/assistant/query';
}

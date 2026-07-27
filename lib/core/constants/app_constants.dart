import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';
}

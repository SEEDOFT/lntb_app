import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Google Sign-In (loaded from .env)
  static String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? '';
}

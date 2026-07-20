import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lntb_app/core/services/firebase_messaging_service.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase (Placeholder for now, requires platform specific configs)
  try {
    await Firebase.initializeApp();
    await FirebaseMessagingService().initialize();
  } on Exception catch (e) {
    debugPrint('Firebase initialization failed (probably missing config): $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LNTB IoT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.notoSansKhmerTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.SPLASH,
      initialBinding: InitialBinding(),
      getPages: AppPages.pages,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lntb_app/core/bindings/initial_binding.dart';
import 'package:lntb_app/core/bootstrap/app_bootstrap.dart';
import 'package:lntb_app/core/services/language_service.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/translations/app_translations.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  await AppBootstrap.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LNTB',
      translations: AppTranslations(),
      locale: LanguageService.to.currentLocale.value,
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.notoSansKhmerTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          margin: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 52),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          elevation: 0,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.primaryLight,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: Routes.SPLASH,
      initialBinding: InitialBinding(),
      getPages: AppPages.pages,
    );
  }
}

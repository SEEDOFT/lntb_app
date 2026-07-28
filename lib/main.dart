import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lntb_app/app/app.dart';
import 'package:lntb_app/core/bootstrap/app_bootstrap.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await _preloadAppFonts();
  await AppBootstrap.init();
  runApp(const LntbAppRoot());
}

Future<void> _preloadAppFonts() {
  final khmer = FontLoader(AppTypography.khmerFont)
    ..addFont(
      rootBundle.load(
        'assets/fonts/Noto_Sans_Khmer/NotoSansKhmer-Regular.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/Noto_Sans_Khmer/NotoSansKhmer-Medium.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/Noto_Sans_Khmer/NotoSansKhmer-SemiBold.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/Noto_Sans_Khmer/NotoSansKhmer-Bold.ttf',
      ),
    );
  final latin = FontLoader(AppTypography.latinFont)
    ..addFont(rootBundle.load('assets/fonts/Noto_Sans/NotoSans-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Noto_Sans/NotoSans-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Noto_Sans/NotoSans-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Noto_Sans/NotoSans-Bold.ttf'));
  final display = FontLoader(AppTypography.displayKhmerFont)
    ..addFont(
      rootBundle.load(
        'assets/fonts/Kantumruy_Pro/KantumruyPro-SemiBold.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'assets/fonts/Kantumruy_Pro/KantumruyPro-Bold.ttf',
      ),
    );

  return Future.wait(<Future<void>>[
    khmer.load(),
    latin.load(),
    display.load(),
  ]);
}

import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String khmerFont = 'NotoSansKhmer';
  static const String latinFont = 'NotoSans';
  static const String displayKhmerFont = 'KantumruyPro';

  static TextTheme textThemeFor(Locale locale) {
    final isKhmer = locale.languageCode == 'km';
    final primaryFont = isKhmer ? khmerFont : latinFont;
    final fallbackFonts =
        isKhmer ? const <String>[latinFont] : const <String>[khmerFont];

    TextStyle style({
      required double size,
      required double height,
      required FontWeight weight,
    }) =>
        TextStyle(
          fontFamily: primaryFont,
          fontFamilyFallback: fallbackFonts,
          fontSize: size,
          height: height,
          fontWeight: weight,
        );

    return TextTheme(
      displayLarge: style(size: 32, height: 1.35, weight: FontWeight.w700),
      displayMedium: style(size: 30, height: 1.35, weight: FontWeight.w700),
      displaySmall: style(size: 28, height: 1.35, weight: FontWeight.w700),
      headlineLarge: style(size: 24, height: 1.4, weight: FontWeight.w700),
      headlineMedium: style(size: 22, height: 1.4, weight: FontWeight.w600),
      headlineSmall: style(size: 20, height: 1.45, weight: FontWeight.w600),
      titleLarge: style(size: 20, height: 1.45, weight: FontWeight.w600),
      titleMedium: style(size: 18, height: 1.45, weight: FontWeight.w600),
      titleSmall: style(size: 16, height: 1.45, weight: FontWeight.w600),
      bodyLarge: style(size: 16, height: 1.55, weight: FontWeight.w400),
      bodyMedium: style(size: 15, height: 1.55, weight: FontWeight.w400),
      bodySmall: style(size: 14, height: 1.5, weight: FontWeight.w400),
      labelLarge: style(size: 16, height: 1.4, weight: FontWeight.w600),
      labelMedium: style(size: 15, height: 1.4, weight: FontWeight.w500),
      labelSmall: style(size: 14, height: 1.4, weight: FontWeight.w500),
    );
  }

  static const TextStyle onboardingTitle = TextStyle(
    fontFamily: displayKhmerFont,
    fontFamilyFallback: <String>[khmerFont, latinFont],
    fontSize: 26,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle sensorValue = TextStyle(
    fontFamily: latinFont,
    fontFamilyFallback: <String>[khmerFont],
    fontSize: 30,
    height: 1.2,
    fontWeight: FontWeight.w700,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );
}

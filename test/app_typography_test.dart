import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

void main() {
  group('AppTypography', () {
    test('uses Noto Sans Khmer for Khmer and Noto Sans for English', () {
      final khmer = AppTypography.textThemeFor(const Locale('km', 'KH'));
      final english = AppTypography.textThemeFor(const Locale('en', 'US'));

      expect(khmer.bodyLarge?.fontFamily, AppTypography.khmerFont);
      expect(
        khmer.bodyLarge?.fontFamilyFallback,
        <String>[AppTypography.latinFont],
      );
      expect(english.bodyLarge?.fontFamily, AppTypography.latinFont);
      expect(
        english.bodyLarge?.fontFamilyFallback,
        <String>[AppTypography.khmerFont],
      );
    });

    test('exposes the approved semantic sizes and Khmer line heights', () {
      final theme = AppTypography.textThemeFor(const Locale('km', 'KH'));

      expect(theme.headlineLarge?.fontSize, 24);
      expect(theme.headlineLarge?.fontWeight, FontWeight.w700);
      expect(theme.titleMedium?.fontSize, 18);
      expect(theme.titleMedium?.fontWeight, FontWeight.w600);
      expect(theme.bodyLarge?.fontSize, 16);
      expect(theme.bodyLarge?.height, 1.55);
      expect(theme.bodySmall?.fontSize, 14);
      expect(theme.labelLarge?.fontSize, 16);
      expect(theme.labelMedium?.fontWeight, FontWeight.w500);
    });

    test('keeps display and sensor typography intentionally specialized', () {
      expect(
        AppTypography.onboardingTitle.fontFamily,
        AppTypography.displayKhmerFont,
      );
      expect(AppTypography.onboardingTitle.fontWeight, FontWeight.w600);
      expect(
        AppTypography.sensorValue.fontFamily,
        AppTypography.latinFont,
      );
      expect(AppTypography.sensorValue.fontSize, 30);
      expect(AppTypography.sensorValue.fontWeight, FontWeight.w700);
      expect(
        AppTypography.sensorValue.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
    });
  });

  testWidgets('changing locale rebuilds text with the matching family', (
    tester,
  ) async {
    final locale = ValueNotifier<Locale>(const Locale('km', 'KH'));
    addTearDown(locale.dispose);

    await tester.pumpWidget(_TypographyHarness(locale: locale));
    expect(_renderedStyle(tester).fontFamily, AppTypography.khmerFont);

    locale.value = const Locale('en', 'US');
    await tester.pump();
    expect(_renderedStyle(tester).fontFamily, AppTypography.latinFont);
  });

  testWidgets('Khmer diacritics render without overflow at large text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: AppTypography.textThemeFor(const Locale('km', 'KH')),
        ),
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Scaffold(
            body: SizedBox(
              width: 320,
              child: Text('សូមស្វាគមន៍មកកាន់កម្មវិធីកសិកម្មឆ្លាតវៃ'),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}

TextStyle _renderedStyle(WidgetTester tester) {
  final text = tester.widget<Text>(find.text('Typography'));
  final context = tester.element(find.text('Typography'));
  return text.style ?? DefaultTextStyle.of(context).style;
}

class _TypographyHarness extends StatelessWidget {
  const _TypographyHarness({required this.locale});

  final ValueNotifier<Locale> locale;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: locale,
      builder: (context, value, child) => MaterialApp(
        locale: value,
        theme: ThemeData(textTheme: AppTypography.textThemeFor(value)),
        home: const Scaffold(body: Text('Typography')),
      ),
    );
  }
}

import 'package:lntb_app/routes/app_routes.dart';

abstract final class StartupRouteResolver {
  static String resolve({
    required bool hasCompletedOnboarding,
    required String? authenticationToken,
  }) {
    if (!hasCompletedOnboarding) return Routes.ONBOARDING;
    if (authenticationToken != null && authenticationToken.isNotEmpty) {
      return Routes.MAIN;
    }
    return Routes.LOGIN;
  }
}

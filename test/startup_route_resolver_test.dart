import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/services/startup_route_resolver.dart';
import 'package:lntb_app/routes/app_routes.dart';

void main() {
  test('fresh installation always opens onboarding first', () {
    final route = StartupRouteResolver.resolve(
      hasCompletedOnboarding: false,
      authenticationToken: null,
    );

    expect(route, Routes.ONBOARDING);
  });

  test('completed onboarding without a session opens login', () {
    final route = StartupRouteResolver.resolve(
      hasCompletedOnboarding: true,
      authenticationToken: null,
    );

    expect(route, Routes.LOGIN);
  });

  test('completed onboarding with a session opens the main app', () {
    final route = StartupRouteResolver.resolve(
      hasCompletedOnboarding: true,
      authenticationToken: 'token',
    );

    expect(route, Routes.MAIN);
  });
}

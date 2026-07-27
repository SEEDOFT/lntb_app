import 'package:get/get.dart';
import 'app_routes.dart';
import 'package:lntb_app/modules/splash/bindings/splash_binding.dart';
import 'package:lntb_app/modules/splash/views/splash_view.dart';
import 'package:lntb_app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:lntb_app/modules/onboarding/views/onboarding_view.dart';
import 'package:lntb_app/modules/auth/bindings/auth_binding.dart';
import 'package:lntb_app/modules/auth/views/login_view.dart';
import 'package:lntb_app/modules/auth/views/register_view.dart';
import 'package:lntb_app/modules/auth/views/auth_success_view.dart';
import 'package:lntb_app/modules/main/bindings/main_binding.dart';
import 'package:lntb_app/modules/main/views/main_view.dart';
import 'package:lntb_app/modules/claim/bindings/claim_binding.dart';
import 'package:lntb_app/modules/claim/views/claim_view.dart';
import 'package:lntb_app/modules/claim/views/claim_success_view.dart';
import 'package:lntb_app/modules/shared_users/bindings/shared_users_binding.dart';
import 'package:lntb_app/modules/shared_users/views/shared_users_view.dart';
import 'package:lntb_app/modules/control/bindings/control_binding.dart';
import 'package:lntb_app/modules/control/views/control_view.dart';
import 'package:lntb_app/modules/notifications/bindings/notification_binding.dart';
import 'package:lntb_app/modules/notifications/views/notifications_view.dart';
import 'package:lntb_app/modules/farm/views/farm_section_views.dart';
import 'package:lntb_app/modules/history/views/history_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.AUTH_SUCCESS,
      page: () => const AuthSuccessView(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.CLAIM,
      page: () => const ClaimView(),
      binding: ClaimBinding(),
    ),
    GetPage(
      name: Routes.CLAIM_SUCCESS,
      page: () => const ClaimSuccessView(),
    ),
    GetPage(
      name: Routes.SHARED_USERS,
      page: () => const SharedUsersView(),
      binding: SharedUsersBinding(),
    ),
    GetPage(
      name: Routes.CONTROL,
      page: () => const ControlView(),
      binding: ControlBinding(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationBinding(),
    ),
    GetPage(name: Routes.FARM_TASKS, page: () => const FarmTasksView()),
    GetPage(name: Routes.ENVIRONMENT, page: () => const EnvironmentView()),
    GetPage(name: Routes.IRRIGATION, page: () => const IrrigationView()),
    GetPage(name: Routes.USAGE, page: () => const UsageView()),
    GetPage(name: Routes.RIPENESS, page: () => const RipenessView()),
    GetPage(name: Routes.FARM_LOG, page: () => const FarmLogView()),
    GetPage(name: Routes.HARVEST, page: () => const HarvestView()),
    GetPage(name: Routes.ASSISTANT, page: () => const AssistantView()),
    GetPage(name: Routes.CONTROL_HISTORY, page: () => const HistoryView()),
  ];
}

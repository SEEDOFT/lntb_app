abstract class AppAssets {
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _svgsPath = 'assets/svgs';

  // PNG Images
  static const String logo = '$_imagesPath/logo.png';
  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';
  static const String splashSmartFarm = '$_imagesPath/splash_smart_farm.png';

  // SVG Assets
  static const String onboardingStep1Farmer =
      '$_svgsPath/onboarding_step_1_farmer.svg';
  static const String onboardingStep2Devices =
      '$_svgsPath/onboarding_step_2_devices.svg';
  static const String onboardingStep3Mobile =
      '$_svgsPath/onboarding_step_3_mobile.svg';
  static const String onboardingStep4Growth =
      '$_svgsPath/onboarding_step_4_growth.svg';
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/constants/app_constants.dart';
import 'package:lntb_app/core/network/api_response.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/services/firebase_messaging_service.dart';
import 'package:lntb_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();
  final countryCodeController = TextEditingController(text: '+855');
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    countryCodeController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      final fcmToken = await FirebaseMessagingService().getToken();

      final response = await apiClient.post(
        ApiEndpoints.login,
        data: {
          'country_code': countryCodeController.text,
          'phone_number': phoneNumberController.text,
          'password': passwordController.text,
          'fcm_token': fcmToken,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
      );

      if (apiResponse.status.success) {
        final token = apiResponse.data['token'];
        if (token != null) {
          await apiClient.storage.write(key: 'auth_token', value: token);
        }
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.snackbar(
          'Login Failed',
          apiResponse.status.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void register(
    String name,
    String countryCode,
    String phoneNumber,
    String password,
    String confirmPassword,
  ) async {
    try {
      isLoading.value = true;
      final fcmToken = await FirebaseMessagingService().getToken();

      final response = await apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'country_code': countryCode,
          'phone_number': phoneNumber,
          'password': password,
          'password_confirmation': confirmPassword,
          'fcm_token': fcmToken,
        },
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
      );

      if (apiResponse.status.success) {
        final token = apiResponse.data['token'];
        if (token != null) {
          await apiClient.storage.write(key: 'auth_token', value: token);
        }
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.snackbar(
          'Registration Failed',
          apiResponse.status.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithGoogle() async {
    try {
      isLoading.value = true;

      await _googleSignIn.initialize(
        serverClientId: AppConstants.googleServerClientId,
      );

      final completer = Completer<String?>();

      late StreamSubscription<GoogleSignInAuthenticationEvent> subscription;
      subscription = _googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          subscription.cancel();
          completer.complete(event.user.authentication.idToken);
        }
      });

      try {
        await _googleSignIn.authenticate();

        final idToken = await completer.future.timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            subscription.cancel();
            return null;
          },
        );

        if (idToken == null || idToken.isEmpty) {
          throw Exception('Failed to get Google ID token');
        }

        final fcmToken = await FirebaseMessagingService().getToken();

        final response = await apiClient.post(
          ApiEndpoints.googleLogin,
          data: {'token': idToken, 'fcm_token': fcmToken},
        );

        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
        );

        if (apiResponse.status.success) {
          final token = apiResponse.data['token'];
          if (token != null) {
            await apiClient.storage.write(key: 'auth_token', value: token);
          }
          Get.offAllNamed(Routes.MAIN);
        } else {
          Get.snackbar(
            'Google Sign-In Failed',
            apiResponse.status.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } on Exception catch (e, s) {
        subscription.cancel();
        debugPrint('Google Sign-In Inner Exception: $e\n$s');
        rethrow;
      }
    } catch (e, s) {
      debugPrint('Google Sign-In Error: $e\n$s');
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void goToLogin() {
    Get.back();
  }
}

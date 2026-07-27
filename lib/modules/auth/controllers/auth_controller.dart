import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lntb_app/core/constants/api_endpoints.dart';
import 'package:lntb_app/core/constants/app_constants.dart';
import 'package:lntb_app/core/network/api_client.dart';
import 'package:lntb_app/core/network/api_response.dart';
import 'package:lntb_app/core/services/fcm_token_sync_service.dart';
import 'package:lntb_app/routes/app_routes.dart';

enum AuthMode { login, register }

class AuthController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final FcmTokenSyncService? fcmTokens = Get.isRegistered<FcmTokenSyncService>()
      ? Get.find<FcmTokenSyncService>()
      : null;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final isLoading = false.obs;
  final mode = AuthMode.login.obs;

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final phoneNumberError = Rx<String?>(null);
  final passwordError = Rx<String?>(null);
  final nameError = Rx<String?>(null);
  final confirmPasswordError = Rx<String?>(null);

  final countryCodeController = TextEditingController(text: '+855');
  final phoneNumberController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void goToRegister() {
    mode.value = AuthMode.register;
    Get.toNamed(Routes.REGISTER);
  }

  void goToLogin() {
    mode.value = AuthMode.login;
    Get.offNamed(Routes.LOGIN);
  }

  Future<void> login() async {
    mode.value = AuthMode.login;
    if (!_validateLogin()) return;
    await submit();
  }

  Future<void> register() async {
    mode.value = AuthMode.register;
    if (!_validateRegister()) return;
    await submit();
  }

  bool _validateLogin() {
    phoneNumberError.value = null;
    passwordError.value = null;

    if (phoneNumberController.text.trim().isEmpty) {
      phoneNumberError.value = 'Phone number is required';
      return false;
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      return false;
    }
    return true;
  }

  bool _validateRegister() {
    nameError.value = null;
    phoneNumberError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Full name is required';
      return false;
    }
    if (phoneNumberController.text.trim().isEmpty) {
      phoneNumberError.value = 'Phone number is required';
      return false;
    }
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      return false;
    }
    if (passwordController.text.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      return false;
    }
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    isLoading.value = true;
    try {
      final registering = mode.value == AuthMode.register;
      final fcmPayload = await fcmTokens?.authenticationPayload() ?? {};
      final data = <String, dynamic>{
        if (registering) 'name': nameController.text.trim(),
        'country_code': countryCodeController.text.trim(),
        'phone_number': phoneNumberController.text.trim(),
        'password': passwordController.text,
        if (registering)
          'password_confirmation': confirmPasswordController.text,
        ...fcmPayload,
      };
      final response = await apiClient.post(
        registering ? ApiEndpoints.register : ApiEndpoints.login,
        data: data,
      );
      
      await _completeAuthentication(
        ApiResponse<Map<String, dynamic>>.fromJson(response.data),
      );

    } catch (error, stackTrace) {
      debugPrint('[AuthController] submit error: $error');
      debugPrint('[AuthController] stackTrace: $stackTrace');
      if (error is DioException) {
        debugPrint('[AuthController] response body: ${error.response?.data}');
      }
      Get.snackbar('authentication_failed'.tr, _message(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _completeAuthentication(
    ApiResponse<Map<String, dynamic>> response,
  ) async {
    final token = response.data['token'] as String?;
    if (token == null) throw Exception('Response missing token field');
    await apiClient.storage.write(key: 'auth_token', value: token);
    await fcmTokens?.syncAuthenticatedDevice();
    final isNew = response.data['is_new_account'] == true;
    Get.offAllNamed(isNew ? Routes.AUTH_SUCCESS : Routes.MAIN);
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    StreamSubscription<GoogleSignInAuthenticationEvent>? subscription;
    try {
      await _googleSignIn.initialize(
        serverClientId: AppConstants.googleServerClientId,
      );
      final completer = Completer<String?>();
      subscription = _googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn &&
            !completer.isCompleted) {
          completer.complete(event.user.authentication.idToken);
        }
      });
      await _googleSignIn.signOut();
      await _googleSignIn.authenticate();
      final idToken =
          await completer.future.timeout(const Duration(seconds: 30));
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Failed to obtain Google ID token.');
      }
      final fcmPayload =
          await fcmTokens?.authenticationPayload() ?? <String, dynamic>{};
      final response = await apiClient.post(
        ApiEndpoints.googleLogin,
        data: {
          'token': idToken,
          ...fcmPayload,
        },
      );
      await _completeAuthentication(
        ApiResponse<Map<String, dynamic>>.fromJson(response.data),
      );
    } catch (error, stackTrace) {
      debugPrint('[AuthController] google error: $error');
      debugPrint('[AuthController] google stackTrace: $stackTrace');
      if (error is DioException) {
        debugPrint('[AuthController] google response body: ${error.response?.data}');
      }
      Get.snackbar('authentication_failed'.tr, _message(error));
    } finally {
      await subscription?.cancel();
      isLoading.value = false;
    }
  }

  String _message(Object error) {
    if (error is DioException) {
      final apiMessage = error.response?.data?['status']?['message'] as String?;
      if (apiMessage != null && apiMessage.isNotEmpty) return apiMessage;
    }
    return error.toString().replaceFirst('Exception: ', '');
  }
}

import 'dart:async';
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

enum AuthMethod { phone, email }

class AuthController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
  final FcmTokenSyncService? fcmTokens = Get.isRegistered<FcmTokenSyncService>()
      ? Get.find<FcmTokenSyncService>()
      : null;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  final isLoading = false.obs;
  final mode = AuthMode.login.obs;
  final method = AuthMethod.phone.obs;
  final formKey = GlobalKey<FormState>();
  final countryCodeController = TextEditingController(text: '+855');
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void goToRegister() {
    mode.value = AuthMode.register;
    Get.toNamed(Routes.REGISTER);
  }

  void goToLogin() {
    mode.value = AuthMode.login;
    Get.offNamed(Routes.LOGIN);
  }

  void choose(AuthMethod value) {
    method.value = value;
    Get.toNamed(Routes.REGISTER);
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      final registering = mode.value == AuthMode.register;
      final fcmPayload = await fcmTokens?.authenticationPayload() ?? {};
      final data = <String, dynamic>{
        if (registering) 'name': nameController.text.trim(),
        if (method.value == AuthMethod.phone) ...{
          'country_code': '+855',
          'phone_number': phoneNumberController.text.trim(),
          if (registering && emailController.text.trim().isNotEmpty)
            'email': emailController.text.trim().toLowerCase(),
        } else ...{
          'email': emailController.text.trim().toLowerCase(),
          if (registering && phoneNumberController.text.trim().isNotEmpty)
            'country_code': '+855',
          if (registering && phoneNumberController.text.trim().isNotEmpty)
            'phone_number': phoneNumberController.text.trim(),
        },
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
    } catch (error) {
      Get.snackbar('authentication_failed'.tr, _message(error));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _completeAuthentication(
    ApiResponse<Map<String, dynamic>> response,
  ) async {
    final token = response.data['token'] as String?;
    if (token == null) throw Exception(response.status.message);
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
    } catch (error) {
      Get.snackbar('authentication_failed'.tr, _message(error));
    } finally {
      await subscription?.cancel();
      isLoading.value = false;
    }
  }

  String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  @override
  void onClose() {
    countryCodeController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

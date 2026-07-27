import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/auth/controllers/auth_controller.dart';
import 'package:lntb_app/modules/auth/widgets/cambodia_country_code_field.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.eco,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      const Text(
                        'LNTB IoT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'phase_one_tagline'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(
                        () => SegmentedButton<AuthMethod>(
                          segments: [
                            ButtonSegment(
                              value: AuthMethod.phone,
                              icon: const Icon(Icons.phone_android),
                              label: Text('phone_number'.tr),
                            ),
                            ButtonSegment(
                              value: AuthMethod.email,
                              icon: const Icon(Icons.alternate_email),
                              label: Text('email'.tr),
                            ),
                          ],
                          selected: {controller.method.value},
                          onSelectionChanged: (selection) {
                            controller.method.value = selection.first;
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Obx(
                        () => controller.method.value == AuthMethod.phone
                            ? _PhoneField(
                                controller: controller.phoneNumberController,
                              )
                            : _AuthField(
                                controller: controller.emailController,
                                label: 'email'.tr,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                      ),
                      const SizedBox(height: 16),
                      _AuthField(
                        controller: controller.passwordController,
                        label: 'password'.tr,
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'login'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'or'.tr,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: controller.loginWithGoogle,
                        icon: const Icon(
                          Icons.g_mobiledata,
                          size: 28,
                          color: Colors.blue,
                        ),
                        label: Text('continue_google'.tr),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${'dont_have_account'.tr} ',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.goToRegister,
                            child: Text(
                              'register'.tr,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 116, child: CambodiaCountryCodeField()),
          const SizedBox(width: 10),
          Expanded(
            child: _AuthField(
              controller: controller,
              label: 'phone_number'.tr,
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      );
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: keyboardType == TextInputType.phone
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'field_required'.tr;
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          suffixIcon:
              obscureText ? const Icon(Icons.visibility_off_outlined) : null,
        ),
      );
}

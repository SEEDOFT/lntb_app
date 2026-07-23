import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/auth/controllers/auth_controller.dart';
import 'package:lntb_app/modules/auth/widgets/cambodia_country_code_field.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

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
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: controller.goToLogin,
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Icon(
                          Icons.person_add,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'create_account'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
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
                      _RegisterField(
                        controller: controller.nameController,
                        label: 'name'.tr,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      Obx(
                        () => controller.method.value == AuthMethod.phone
                            ? _PhoneField(
                                controller: controller.phoneNumberController,
                              )
                            : _RegisterField(
                                controller: controller.emailController,
                                label: 'email'.tr,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                      ),
                      const SizedBox(height: 16),
                      _RegisterField(
                        controller: controller.passwordController,
                        label: 'password'.tr,
                        icon: Icons.lock_outline,
                        obscureText: true,
                        minimumLength: 12,
                      ),
                      const SizedBox(height: 16),
                      _RegisterField(
                        controller: controller.confirmPasswordController,
                        label: 'confirm_password'.tr,
                        icon: Icons.lock_outline,
                        obscureText: true,
                        matches: controller.passwordController,
                      ),
                      const SizedBox(height: 28),
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
                                  'register'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${'already_have_account'.tr} ',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.goToLogin,
                            child: Text(
                              'login'.tr,
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
            child: _RegisterField(
              controller: controller,
              label: 'phone_number'.tr,
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      );
}

class _RegisterField extends StatelessWidget {
  const _RegisterField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.minimumLength,
    this.matches,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? minimumLength;
  final TextEditingController? matches;

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
          if (minimumLength != null && value.length < minimumLength!) {
            return 'password_min'.tr;
          }
          if (matches != null && value != matches!.text) {
            return 'passwords_not_match'.tr;
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

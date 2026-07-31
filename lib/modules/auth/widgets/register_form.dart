import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/widgets/app_cambodia_country_code_field.dart';
import 'package:lntb_app/core/widgets/app_field_error.dart';
import 'package:lntb_app/core/widgets/app_text_field.dart';
import 'package:lntb_app/modules/auth/controllers/auth_controller.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key, required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: .08),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'create_account'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'register_subtitle'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: controller.nameController,
              prefixIcon: const Icon(Icons.person_outline_rounded),
              hintText: 'name'.tr,
            ),
            Obx(
              () => controller.nameError.value == null
                  ? const SizedBox.shrink()
                  : AppFieldError(message: controller.nameError.value!),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 112,
                  child: AppCambodiaCountryCodeField(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    controller: controller.phoneNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    hintText: 'phone_number'.tr,
                  ),
                ),
              ],
            ),
            Obx(
              () => controller.phoneNumberError.value == null
                  ? const SizedBox.shrink()
                  : AppFieldError(message: controller.phoneNumberError.value!),
            ),
            const SizedBox(height: 14),
            Obx(
              () => AppTextField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                hintText: 'password'.tr,
              ),
            ),
            Obx(
              () => controller.passwordError.value == null
                  ? const SizedBox.shrink()
                  : AppFieldError(message: controller.passwordError.value!),
            ),
            const SizedBox(height: 14),
            Obx(
              () => AppTextField(
                controller: controller.confirmPasswordController,
                obscureText: !controller.isConfirmPasswordVisible.value,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
                hintText: 'confirm_password'.tr,
              ),
            ),
            Obx(
              () => controller.confirmPasswordError.value == null
                  ? const SizedBox.shrink()
                  : AppFieldError(
                      message: controller.confirmPasswordError.value!,
                    ),
            ),
            const SizedBox(height: 22),
            Obx(
              () => SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: .55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 21,
                          width: 21,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'register'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'already_have_account'.tr,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                TextButton(
                  onPressed: controller.goToLogin,
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
      );
}

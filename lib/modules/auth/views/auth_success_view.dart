import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/routes/app_routes.dart';

class AuthSuccessView extends StatelessWidget {
  const AuthSuccessView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Spacer(),
                const CircleAvatar(
                  radius: 54,
                  backgroundColor: AppColors.success,
                  child: Icon(
                    Icons.check_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'account_created'.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w800,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text('welcome_to_lntb'.tr, textAlign: TextAlign.center),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Get.offAllNamed(Routes.MAIN),
                    child: Text('enter_application'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

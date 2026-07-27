import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/routes/app_routes.dart';

class ClaimSuccessView extends StatelessWidget {
  const ClaimSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final device = Get.arguments as DeviceModel;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 54,
                backgroundColor: AppColors.success,
                child: Icon(Icons.check_rounded, size: 72, color: Colors.white),
              ),
              const SizedBox(height: 26),
              Text(
                'device_claimed'.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 18),
              Card(
                elevation: 0,
                child: ListTile(
                  leading: const Icon(
                    Icons.energy_savings_leaf,
                    color: AppColors.primary,
                  ),
                  title: Text(device.name),
                  subtitle: Text(device.macAddress),
                ),
              ),
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
}

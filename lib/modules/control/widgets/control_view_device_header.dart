import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class ControlDeviceHeader extends StatelessWidget {
  const ControlDeviceHeader({super.key, required this.device});
  final DeviceModel device;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFEAF3FF),
                child: Icon(
                  Icons.energy_savings_leaf,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.deviceDisplayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      device.macAddress,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    Text(
                      '${device.firmwareVersion ?? '-'} • ${device.accessRole.tr}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                device.status.tr,
                style: TextStyle(
                  color: device.isOnline
                      ? AppColors.success
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/control/widgets/control_view_toggle.dart';

class ControlViewDailyControlCard extends StatelessWidget {
  const ControlViewDailyControlCard({
    super.key,
    required this.isFan,
    required this.isRoof,
    required this.isCamera,
    required this.fanRunning,
    required this.roofOpen,
    required this.enabled,
    required this.onCommand,
  });

  final bool isFan;
  final bool isRoof;
  final bool isCamera;
  final bool fanRunning;
  final bool roofOpen;
  final bool enabled;
  final ValueChanged<String> onCommand;

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.primaryLight,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
                child: Text(
                  'daily_control'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (isFan)
                ControlToggle(
                  title: 'fan'.tr,
                  icon: Icons.air_rounded,
                  value: fanRunning,
                  enabled: enabled,
                  onChanged: (value) =>
                      onCommand(value ? 'fan.start' : 'fan.stop'),
                ),
              if (isRoof)
                ControlToggle(
                  title: 'roof'.tr,
                  icon: Icons.roofing_outlined,
                  value: roofOpen,
                  enabled: enabled,
                  onChanged: (value) =>
                      onCommand(value ? 'roof.open' : 'roof.close'),
                ),
              if (isCamera)
                ControlToggle(
                  title: 'camera'.tr,
                  icon: Icons.camera_alt_outlined,
                  value: false,
                  button: true,
                  enabled: enabled,
                  onChanged: (_) => onCommand('camera.capture'),
                ),
            ],
          ),
        ),
      );
}

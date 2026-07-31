import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/modules/devices/widgets/devices_view_device_card.dart';

class ControlDeviceHeader extends StatelessWidget {
  const ControlDeviceHeader({super.key, required this.device});
  final DeviceModel device;
  @override
  Widget build(BuildContext context) {
    final style = DeviceTypeStyles.of(device);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            style.gradient.colors.first,
            style.gradient.colors.last,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: style.gradient.colors.first.withValues(alpha: .35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(style.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.deviceDisplayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      device.macAddress,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${device.firmwareVersion ?? '-'} • ${device.accessRole.tr}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: device.isOnline
                          ? Colors.white
                          : Colors.white.withValues(alpha: .55),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      device.status.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

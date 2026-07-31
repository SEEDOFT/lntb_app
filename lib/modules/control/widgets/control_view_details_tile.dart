import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/utils/app_date_formatter.dart';

class ControlViewDetailsTile extends StatelessWidget {
  const ControlViewDetailsTile({super.key, required this.device});

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('device_details'.tr),
      leading: const Icon(Icons.info_outline),
      children: [
        ListTile(
          title: Text('firmware'.tr),
          trailing: Text(
            device.firmwareVersion ?? 'unavailable'.tr,
          ),
        ),
        ListTile(
          title: Text('last_sync'.tr),
          trailing: Text(
            device.lastSeenAt?.toAppFormattedString() ?? 'unavailable'.tr,
          ),
        ),
        ListTile(
          title: Text('connection'.tr),
          trailing: Text(
            device.isOnline ? 'online'.tr : 'offline'.tr,
          ),
        ),
      ],
    );
  }
}

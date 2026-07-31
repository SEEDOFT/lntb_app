import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/utils/app_date_formatter.dart';
import 'package:lntb_app/modules/control/controllers/control_controller.dart';

class ControlViewDetailsTile extends StatelessWidget {
  const ControlViewDetailsTile({super.key, required this.device});

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControlController>();

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
        ListTile(
          title: Text('rated_power'.tr),
          trailing: device.isOwner
              ? TextButton.icon(
                  onPressed: () => _editPower(context, controller),
                  icon: const Icon(Icons.bolt, size: 18),
                  label: Text(
                    device.ratedPowerWatts != null
                        ? '${device.ratedPowerWatts} ${'watts'.tr}'
                        : 'power_empty_hint'.tr,
                  ),
                )
              : Text(
                  device.ratedPowerWatts != null
                      ? '${device.ratedPowerWatts} ${'watts'.tr}'
                      : 'unavailable'.tr,
                ),
        ),
      ],
    );
  }

  Future<void> _editPower(
    BuildContext context,
    ControlController controller,
  ) async {
    final textController = TextEditingController(
      text: device.ratedPowerWatts?.toString() ?? '',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('edit_power_title'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('edit_power_message'.tr),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'power_label'.tr,
                suffixText: 'watts'.tr,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text('save_power'.tr),
          ),
        ],
      ),
    );

    if (saved == true) {
      final input = textController.text.trim();
      final watts = input.isEmpty ? null : int.tryParse(input);
      if (watts != null && watts < 1) {
        Get.snackbar('power_update_failed'.tr, 'invalid_input'.tr);
        return;
      }
      final ok = await controller.updateRatedPower(watts);
      if (ok) {
        Get.snackbar('power_updated'.tr, '');
      }
    }
    textController.dispose();
  }
}

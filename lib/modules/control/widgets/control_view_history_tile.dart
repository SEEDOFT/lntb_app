import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/translations/control_type_labels.dart';
import 'package:lntb_app/core/utils/app_date_formatter.dart';

class ControlHistoryTile extends StatelessWidget {
  const ControlHistoryTile({super.key, required this.record});
  final ControlRecord record;
  @override
  Widget build(BuildContext context) {
    final color = record.isPending
        ? Colors.orange
        : record.isCompleted
            ? AppColors.success
            : AppColors.error;
    return ListTile(
      leading: Icon(
        record.isCompleted
            ? Icons.check_circle
            : record.isPending
                ? Icons.schedule
                : Icons.error,
        color: color,
      ),
      title: Text(record.controlType.controlTypeLabel),
      subtitle: Text(record.requestedAt.toAppFormattedString()),
      trailing: Text(
        record.status.tr,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

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
      title: Text(record.controlType.tr),
      subtitle: Text(record.requestedAt.toLocal().toString().substring(0, 16)),
      trailing: Text(
        record.status.tr,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

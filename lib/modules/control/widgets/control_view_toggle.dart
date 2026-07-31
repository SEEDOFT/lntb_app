import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class ControlToggle extends StatelessWidget {
  const ControlToggle({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.button = false,
    this.enabled = true,
  });
  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool button;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          trailing: button
              ? IconButton(
                  onPressed: enabled ? () => onChanged(true) : null,
                  icon: const Icon(Icons.play_circle, color: AppColors.primary),
                )
              : Switch(
                  value: value,
                  onChanged: enabled ? onChanged : null,
                  activeThumbColor: AppColors.success,
                ),
        ),
      );
}

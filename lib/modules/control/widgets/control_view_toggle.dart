import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class ControlToggle extends StatefulWidget {
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
  State<ControlToggle> createState() => _ControlToggleState();
}

class _ControlToggleState extends State<ControlToggle> {
  late bool _local;

  @override
  void initState() {
    super.initState();
    _local = widget.value;
  }

  @override
  void didUpdateWidget(covariant ControlToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) _local = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final active = _local;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? AppColors.primary.withValues(alpha: .35) : AppColors.cardBorder,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary.withValues(alpha: .14)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            widget.icon,
            color: active ? AppColors.primary : AppColors.textMuted,
            size: 24,
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: active && !widget.button
            ? Text(
                'active'.tr,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              )
            : null,
        trailing: widget.button
            ? AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: active ? 1.15 : 1,
                child: IconButton.filled(
                  onPressed:
                      widget.enabled ? () => widget.onChanged(true) : null,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  tooltip: 'activate'.tr,
                ),
              )
            : Switch(
                value: active,
                onChanged: widget.enabled
                    ? (value) {
                        setState(() => _local = value);
                        widget.onChanged(value);
                      }
                    : null,
                activeThumbColor: AppColors.primary,
                activeTrackColor: AppColors.primaryLight,
                inactiveTrackColor: const Color(0xFFE2E8F0),
              ),
      ),
    );
  }
}

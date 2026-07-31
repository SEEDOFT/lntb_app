import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class QrScannerAction extends StatelessWidget {
  const QrScannerAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isBusy = false,
    this.isSelected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isBusy;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final background =
        isSelected ? AppColors.primary : Colors.black.withValues(alpha: 0.48);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 104,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBusy)
                const SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  icon,
                  color: onPressed == null ? Colors.white54 : Colors.white,
                ),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: onPressed == null ? Colors.white54 : Colors.white,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

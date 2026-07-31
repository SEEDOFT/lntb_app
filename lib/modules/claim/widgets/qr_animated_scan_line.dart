import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class QrAnimatedScanLine extends StatefulWidget {
  const QrAnimatedScanLine({super.key, required this.target});

  final Rect target;

  @override
  State<QrAnimatedScanLine> createState() => _QrAnimatedScanLineState();
}

class _QrAnimatedScanLineState extends State<QrAnimatedScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.target.left + 18,
      top: widget.target.top + 18,
      width: widget.target.width - 36,
      height: widget.target.height - 36,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Align(
            alignment: Alignment(0, (_animation.value * 2) - 1),
            child: child,
          ),
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.85),
              boxShadow: const [
                BoxShadow(color: AppColors.success, blurRadius: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

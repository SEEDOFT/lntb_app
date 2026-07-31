import 'package:flutter/material.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class QrTargetPainter extends CustomPainter {
  const QrTargetPainter({required this.target});

  final Rect target;

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRRect(RRect.fromRectAndRadius(target, const Radius.circular(22)));
    canvas.drawPath(
      overlay,
      Paint()..color = Colors.black.withValues(alpha: 0.56),
    );

    final cornerPaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const corner = 34.0;
    final left = target.left;
    final right = target.right;
    final top = target.top;
    final bottom = target.bottom;

    canvas.drawLine(Offset(left, top + corner), Offset(left, top), cornerPaint);
    canvas.drawLine(Offset(left, top), Offset(left + corner, top), cornerPaint);
    canvas.drawLine(
      Offset(right - corner, top),
      Offset(right, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right, top + corner),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, bottom - corner),
      Offset(left, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + corner, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right - corner, bottom),
      Offset(right, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right, bottom - corner),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(QrTargetPainter oldDelegate) =>
      oldDelegate.target != target;
}

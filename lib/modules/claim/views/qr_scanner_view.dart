import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/claim/controllers/qr_scanner_controller.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerView extends GetView<QrScannerController> {
  const QrScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final targetSize = math.min(size.width - 56, 280.0);
          final target = Rect.fromCenter(
            center: Offset(size.width / 2, size.height * 0.43),
            width: targetSize,
            height: targetSize,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: controller.scanner,
                scanWindow: target,
                scanWindowUpdateThreshold: 8,
                onDetect: controller.handleCapture,
                errorBuilder: (context, error) => _CameraError(
                  onRetry: controller.retryCamera,
                ),
              ),
              IgnorePointer(
                child: CustomPaint(
                  painter: _QrTargetPainter(target: target),
                ),
              ),
              _AnimatedScanLine(target: target),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    children: [
                      _ScannerHeader(onClose: Get.back),
                      const Spacer(),
                      Text(
                        'scanner_instruction'.tr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => _ScannerAction(
                              icon: Icons.photo_library_outlined,
                              label: 'import_qr'.tr,
                              isBusy: controller.isImporting.value,
                              onPressed: controller.isImporting.value
                                  ? null
                                  : controller.importFromGallery,
                            ),
                          ),
                          const SizedBox(width: 20),
                          ValueListenableBuilder<MobileScannerState>(
                            valueListenable: controller.scanner,
                            builder: (context, state, child) {
                              final unavailable =
                                  state.torchState == TorchState.unavailable;
                              final enabled = state.torchState == TorchState.on;
                              return _ScannerAction(
                                icon: enabled
                                    ? Icons.flashlight_on_rounded
                                    : Icons.flashlight_off_rounded,
                                label: 'flashlight'.tr,
                                isSelected: enabled,
                                onPressed:
                                    unavailable ? null : controller.toggleTorch,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScannerHeader extends StatelessWidget {
  const _ScannerHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          onPressed: onClose,
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withValues(alpha: 0.42),
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.close_rounded),
        ),
        Expanded(
          child: Text(
            'scan_qr'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _ScannerAction extends StatelessWidget {
  const _ScannerAction({
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

class _CameraError extends StatelessWidget {
  const _CameraError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF101713),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.no_photography_outlined,
                  size: 52,
                  color: Colors.white,
                ),
                const SizedBox(height: 18),
                Text(
                  'camera_unavailable'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'camera_permission_help'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: onRetry,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedScanLine extends StatefulWidget {
  const _AnimatedScanLine({required this.target});

  final Rect target;

  @override
  State<_AnimatedScanLine> createState() => _AnimatedScanLineState();
}

class _AnimatedScanLineState extends State<_AnimatedScanLine>
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

class _QrTargetPainter extends CustomPainter {
  const _QrTargetPainter({required this.target});

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
  bool shouldRepaint(_QrTargetPainter oldDelegate) =>
      oldDelegate.target != target;
}

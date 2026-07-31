import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/modules/claim/controllers/qr_scanner_controller.dart';
import 'package:lntb_app/modules/claim/widgets/qr_animated_scan_line.dart';
import 'package:lntb_app/modules/claim/widgets/qr_camera_error.dart';
import 'package:lntb_app/modules/claim/widgets/qr_scanner_action.dart';
import 'package:lntb_app/modules/claim/widgets/qr_scanner_header.dart';
import 'package:lntb_app/modules/claim/widgets/qr_target_painter.dart';
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
                errorBuilder: (context, error) => QrCameraError(
                  onRetry: controller.retryCamera,
                ),
              ),
              IgnorePointer(
                child: CustomPaint(
                  painter: QrTargetPainter(target: target),
                ),
              ),
              QrAnimatedScanLine(target: target),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Column(
                    children: [
                      QrScannerHeader(onClose: Get.back),
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
                            () => QrScannerAction(
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
                              return QrScannerAction(
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

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerController extends GetxController {
  QrScannerController({ImagePicker? imagePicker})
      : imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker imagePicker;
  final MobileScannerController scanner = MobileScannerController(
    facing: CameraFacing.back,
    formats: const <BarcodeFormat>[BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 250,
  );
  final isImporting = false.obs;

  bool _handled = false;
  String? _lastInvalidRaw;
  DateTime? _lastInvalidAt;

  ClaimPayload parseQr(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unsupported device QR code.');
    }
    return ClaimPayload.fromJson(decoded);
  }

  Future<void> handleCapture(BarcodeCapture capture) async {
    if (_handled || isImporting.value) return;

    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.trim().isEmpty) continue;
      await _handleRaw(raw);
      return;
    }
  }

  Future<void> importFromGallery() async {
    if (_handled || isImporting.value) return;

    isImporting.value = true;
    await _stopScanner();
    try {
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final capture = await scanner.analyzeImage(
        image.path,
        formats: const <BarcodeFormat>[BarcodeFormat.qrCode],
      );
      if (capture == null || capture.barcodes.isEmpty) {
        _showInvalid(null, 'qr_not_found'.tr);
        return;
      }

      final raw = capture.barcodes
          .map((barcode) => barcode.rawValue)
          .whereType<String>()
          .firstOrNull;
      if (raw == null || raw.trim().isEmpty) {
        _showInvalid(null, 'qr_not_found'.tr);
        return;
      }
      await _handleRaw(raw);
    } on UnsupportedError {
      Get.snackbar('scan_failed'.tr, 'gallery_scan_unsupported'.tr);
    } catch (_) {
      Get.snackbar('scan_failed'.tr, 'gallery_scan_failed'.tr);
    } finally {
      isImporting.value = false;
      if (!_handled) {
        await _startScanner();
      }
    }
  }

  Future<void> toggleTorch() async {
    if (scanner.value.torchState == TorchState.unavailable) return;
    try {
      await scanner.toggleTorch();
    } catch (_) {
      Get.snackbar('flashlight'.tr, 'flashlight_unavailable'.tr);
    }
  }

  void retryCamera() {
    unawaited(_startScanner());
  }

  Future<void> _handleRaw(String raw) async {
    try {
      final payload = parseQr(raw);
      _handled = true;
      await _stopScanner();
      Get.back<ClaimPayload>(result: payload);
    } catch (_) {
      _showInvalid(raw, 'unsupported_device_qr'.tr);
    }
  }

  void _showInvalid(String? raw, String message) {
    final now = DateTime.now();
    final recentlyShown = raw == _lastInvalidRaw &&
        _lastInvalidAt != null &&
        now.difference(_lastInvalidAt!) < const Duration(seconds: 2);
    if (recentlyShown) return;

    _lastInvalidRaw = raw;
    _lastInvalidAt = now;
    Get.snackbar('invalid_qr'.tr, message);
  }

  Future<void> _startScanner() async {
    try {
      await scanner.start();
    } catch (_) {
      // MobileScanner's errorBuilder presents camera and permission failures.
    }
  }

  Future<void> _stopScanner() async {
    try {
      await scanner.stop();
    } catch (_) {
      // The scanner may already be stopped while a route is closing.
    }
  }

  @override
  void onClose() {
    unawaited(scanner.dispose());
    super.onClose();
  }
}

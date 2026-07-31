import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrScannerHeader extends StatelessWidget {
  const QrScannerHeader({super.key, required this.onClose});

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

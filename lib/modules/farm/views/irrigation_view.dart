import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/routes/app_routes.dart';

class IrrigationView extends StatelessWidget {
  const IrrigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('irrigation'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _InfoCard(
            icon: Icons.auto_mode,
            title: 'automatic_irrigation'.tr,
            body: 'irrigation_api_required'.tr,
          ),
          _InfoCard(
            icon: Icons.tune,
            title: 'moisture_threshold'.tr,
            body: 'configured_by_backend'.tr,
          ),
          const SizedBox(height: 20),
          Text(
            'manual_controls'.tr,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text('manual_control_device_help'.tr),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => Get.offAllNamed(Routes.MAIN),
            icon: const Icon(Icons.router),
            label: Text('open_devices'.tr),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(body),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/controllers/harvest_controller.dart';

class HarvestView extends GetView<HarvestController> {
  const HarvestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('harvest'.tr)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addHarvest(context),
        icon: const Icon(Icons.add),
        label: Text('add_harvest'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.records.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.records.isEmpty) {
          return Center(child: Text('no_harvest_records'.tr));
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.records.length,
            itemBuilder: (_, index) {
              final record = controller.records[index];
              return ListTile(
                leading:
                    const Icon(Icons.agriculture, color: AppColors.success),
                title: Text('${record.quantity} ${record.unit}'),
                subtitle: Text(record.grade ?? 'ungraded'.tr),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _addHarvest(BuildContext context) async {
    final quantityController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_harvest'.tr),
        content: TextField(
          controller: quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'quantity_kg'.tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(quantityController.text);
              if (value != null) {
                controller.addHarvest(value, 'kg');
              }
              Navigator.pop(context);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }
}

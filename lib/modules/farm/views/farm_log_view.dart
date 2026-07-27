import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/controllers/farm_log_controller.dart';

class FarmLogView extends GetView<FarmLogController> {
  const FarmLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('farm_log'.tr),
        actions: [
          IconButton(
            onPressed: () => _showLogDialog(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.logs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.logs.isEmpty) {
          return Center(child: Text('no_farm_logs'.tr));
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.logs.length,
            itemBuilder: (_, index) {
              final log = controller.logs[index];
              return ListTile(
                leading:
                    const Icon(Icons.menu_book, color: AppColors.primary),
                title: Text(log.title),
                subtitle: Text(log.notes ?? log.type.tr),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _showLogDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_log'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'title'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'notes'.tr),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final notes = notesController.text.trim();
              if (title.isNotEmpty) {
                controller.createLog(title, notes);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }
}

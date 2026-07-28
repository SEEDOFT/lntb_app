import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/controllers/farm_tasks_controller.dart';

class FarmTasksView extends GetView<FarmTasksController> {
  const FarmTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('today_tasks'.tr),
        actions: [
          IconButton(
            onPressed: () => _addTask(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.tasks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.tasks.isEmpty) {
          return Center(child: Text('no_tasks'.tr));
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.tasks.length,
            itemBuilder: (_, index) {
              final task = controller.tasks[index];
              return Card(
                elevation: 0,
                child: ListTile(
                  leading: Icon(
                    task.source == 'manual'
                        ? Icons.edit_note
                        : Icons.auto_awesome,
                    color: AppColors.primary,
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.description ?? task.source.tr),
                  trailing: PopupMenuButton<String>(
                    onSelected: (action) =>
                        controller.updateTask(task.id, action),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'complete',
                        child: Text('complete'.tr),
                      ),
                      PopupMenuItem(
                        value: 'dismiss',
                        child: Text('dismiss'.tr),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _addTask(BuildContext context) async {
    final textController = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_task'.tr),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(labelText: 'task_title'.tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, textController.text.trim()),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
    if (title != null && title.isNotEmpty) {
      controller.createTask(title);
    }
  }
}

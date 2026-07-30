import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/config/app_data_source.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/widgets/demo_data_banner.dart';

class FarmLogView extends StatefulWidget {
  const FarmLogView({super.key});
  @override
  State<FarmLogView> createState() => _FarmLogViewState();
}

class _FarmLogViewState extends State<FarmLogView> {
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    if (!AppDataSourceConfig.isDemo) {
      return Scaffold(
        appBar: AppBar(title: Text('digital_log'.tr)),
        body: Center(child: Text('farm_api_pending'.tr)),
      );
    }
    final demo = Get.find<DemoPrototypeRepository>();
    return Scaffold(
      appBar: AppBar(
        title: Text('digital_log'.tr),
        actions: [
          IconButton(
            onPressed: () => _addNote(context, demo),
            icon: const Icon(Icons.note_add_outlined),
            tooltip: 'add_log'.tr,
          ),
        ],
      ),
      body: Obx(() {
        final events = filter == 'all'
            ? demo.events
            : demo.events.where((event) => event.type == filter).toList();
        return ListView(
          padding: const EdgeInsets.only(bottom: 28),
          children: [
            const DemoDataBanner(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Wrap(
                spacing: 8,
                children: [
                  'all',
                  'command',
                  'irrigation',
                  'warning',
                  'ripeness',
                  'note'
                ]
                    .map(
                      (value) => ChoiceChip(
                        label: Text(value.tr),
                        selected: filter == value,
                        onSelected: (_) => setState(() => filter = value),
                      ),
                    )
                    .toList(),
              ),
            ),
            if (events.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text('no_farm_logs'.tr)),
              )
            else
              ...events.map(
                (event) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child:
                            Icon(_icon(event.type), color: AppColors.primary),
                      ),
                      title: Text(event.title.tr),
                      subtitle: Text(
                        '${event.zone} • ${event.device}\n'
                        '${event.actor}${event.detail == null ? '' : ' • ${event.detail}'}',
                      ),
                      isThreeLine: true,
                      trailing: event.offlineReplay
                          ? Tooltip(
                              message: 'offline_replayed'.tr,
                              child: const Icon(Icons.cloud_sync_outlined),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  IconData _icon(String type) => switch (type) {
        'command' => Icons.touch_app_outlined,
        'irrigation' => Icons.water_drop_outlined,
        'warning' => Icons.warning_amber_outlined,
        'ripeness' => Icons.camera_alt_outlined,
        _ => Icons.edit_note,
      };

  Future<void> _addNote(
    BuildContext context,
    DemoPrototypeRepository demo,
  ) async {
    final title = TextEditingController();
    final detail = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_log'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: title,
                decoration: InputDecoration(labelText: 'title'.tr)),
            const SizedBox(height: 10),
            TextField(
              controller: detail,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'notes'.tr),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr)),
          FilledButton(
            onPressed: () {
              if (title.text.trim().isNotEmpty) {
                demo.addNote(title.text.trim(), detail.text.trim());
              }
              Navigator.pop(context);
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );
    title.dispose();
    detail.dispose();
  }
}

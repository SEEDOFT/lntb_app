import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/controllers/farm_context_controller.dart';
import 'package:lntb_app/core/models/farm/farm_log.dart';
import 'package:lntb_app/core/models/farm/farm_models.dart';
import 'package:lntb_app/core/models/farm/farm_task.dart';
import 'package:lntb_app/core/models/farm/harvest_record.dart';
import 'package:lntb_app/core/models/farm/ripeness_result.dart';
import 'package:lntb_app/core/models/farm/usage_summary.dart';
import 'package:lntb_app/core/models/repository_state.dart';
import 'package:lntb_app/core/repositories/farm_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/widgets/repository_state_view.dart';
import 'package:lntb_app/routes/app_routes.dart';

int? get _farmId => Get.find<FarmContextController>().selectedFarm.value?.id;

class FarmTasksView extends StatefulWidget {
  const FarmTasksView({super.key});
  @override
  State<FarmTasksView> createState() => _FarmTasksViewState();
}

class _FarmTasksViewState extends State<FarmTasksView> {
  final repository = Get.find<FarmRepository>();
  late Future<RepositoryState<List<FarmTask>>> future;

  @override
  void initState() {
    super.initState();
    future = _load();
  }

  Future<RepositoryState<List<FarmTask>>> _load() async {
    final farmId = _farmId;
    if (farmId == null) {
      return const RepositoryState.empty();
    }

    return await repository.getTasks(farmId);
  }

  void _reload() => setState(() => future = _load());

  Future<void> _add() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_task'.tr),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'task_title'.tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
    if (title == null || title.isEmpty || _farmId == null) return;
    await repository.createTask(_farmId!, title: title);
    _reload();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('today_tasks'.tr),
          actions: [IconButton(onPressed: _add, icon: const Icon(Icons.add))],
        ),
        body: FutureBuilder<RepositoryState<List<FarmTask>>>(
          future: future,
          builder: (context, snapshot) => RepositoryStateView<List<FarmTask>>(
            state: snapshot.data ?? const RepositoryState.loading(),
            onRetry: _reload,
            emptyMessageKey: 'no_tasks',
            dataBuilder: (tasks) => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];
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
                      onSelected: (action) async {
                        await repository.updateTask(
                          _farmId!,
                          task.id,
                          action,
                        );
                        _reload();
                      },
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
          ),
        ),
      );
}

class EnvironmentView extends StatelessWidget {
  const EnvironmentView({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = Get.find<FarmRepository>();
    final future = _farmId == null
        ? Future.value(const RepositoryState<List<SensorMetric>>.empty())
        : repository.getTelemetry(_farmId!);
    return Scaffold(
      appBar: AppBar(title: Text('environment'.tr)),
      body: FutureBuilder<RepositoryState<List<SensorMetric>>>(
        future: future,
        builder: (context, snapshot) => RepositoryStateView<List<SensorMetric>>(
          state: snapshot.data ?? const RepositoryState.loading(),
          onRetry: () => Get.offNamed(Routes.ENVIRONMENT),
          emptyMessageKey: 'no_sensor_data',
          dataBuilder: (metrics) => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.05,
            ),
            itemCount: metrics.length,
            itemBuilder: (_, index) {
              final metric = metrics[index];
              final warning =
                  metric.status == 'warning' || metric.status == 'critical';
              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _metricIcon(metric.code),
                        color: warning ? AppColors.error : AppColors.success,
                        size: 34,
                      ),
                      const SizedBox(height: 8),
                      Text(metric.code.tr),
                      Text(
                        '${metric.value.toStringAsFixed(1)} ${metric.unit}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        metric.status.tr,
                        style: TextStyle(
                          color: warning ? AppColors.error : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _metricIcon(String code) => switch (code) {
        'soil_moisture' => Icons.water_drop_outlined,
        'temperature' => Icons.thermostat,
        'humidity' => Icons.water,
        'light' => Icons.light_mode_outlined,
        _ => Icons.sensors,
      };
}

class IrrigationView extends StatelessWidget {
  const IrrigationView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
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

class UsageView extends StatelessWidget {
  const UsageView({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = Get.find<FarmRepository>();
    final future = _farmId == null
        ? Future.value(const RepositoryState<List<UsageSummary>>.empty())
        : repository.getUsage(_farmId!);
    return Scaffold(
      appBar: AppBar(title: Text('usage_cost'.tr)),
      body: FutureBuilder<RepositoryState<List<UsageSummary>>>(
        future: future,
        builder: (context, snapshot) => RepositoryStateView<List<UsageSummary>>(
          state: snapshot.data ?? const RepositoryState.loading(),
          onRetry: () => Get.offNamed(Routes.USAGE),
          emptyMessageKey: 'no_usage_data',
          dataBuilder: (items) => ListView(
            padding: const EdgeInsets.all(16),
            children: items
                .map(
                  (item) => Card(
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(
                        Icons.paid_outlined,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        '\$${item.totalCostUsd.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        '${item.waterCubicMeters.toStringAsFixed(2)} m³ • '
                        '${item.electricityKwh.toStringAsFixed(2)} kWh',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class RipenessView extends StatelessWidget {
  const RipenessView({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = Get.find<FarmRepository>();
    final future = _farmId == null
        ? Future.value(const RepositoryState<List<RipenessResult>>.empty())
        : repository.getRipeness(_farmId!);
    return Scaffold(
      appBar: AppBar(title: Text('ripeness'.tr)),
      body: FutureBuilder<RepositoryState<List<RipenessResult>>>(
        future: future,
        builder: (context, snapshot) =>
            RepositoryStateView<List<RipenessResult>>(
          state: snapshot.data ?? const RepositoryState.loading(),
          onRetry: () => Get.offNamed(Routes.RIPENESS),
          emptyMessageKey: 'no_ripeness_results',
          dataBuilder: (items) => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .78,
            ),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: Column(
                  children: [
                    Expanded(
                      child: item.imageUrl == null
                          ? const ColoredBox(
                              color: Color(0xFFEAF4EA),
                              child: Center(
                                child: Icon(Icons.image_outlined, size: 48),
                              ),
                            )
                          : Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image_outlined),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            item.stage.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${(item.confidence * 100).toStringAsFixed(0)}%',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FarmLogView extends StatelessWidget {
  const FarmLogView({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = Get.find<FarmRepository>();
    final future = _farmId == null
        ? Future.value(const RepositoryState<List<FarmLog>>.empty())
        : repository.getLogs(_farmId!);
    return Scaffold(
      appBar: AppBar(
        title: Text('farm_log'.tr),
        actions: [
          IconButton(
            onPressed: () => _showLogDialog(context, repository),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<RepositoryState<List<FarmLog>>>(
        future: future,
        builder: (context, snapshot) => RepositoryStateView<List<FarmLog>>(
          state: snapshot.data ?? const RepositoryState.loading(),
          onRetry: () => Get.offNamed(Routes.FARM_LOG),
          emptyMessageKey: 'no_farm_logs',
          dataBuilder: (items) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, index) => ListTile(
              leading: const Icon(Icons.menu_book, color: AppColors.primary),
              title: Text(items[index].title),
              subtitle: Text(items[index].notes ?? items[index].type.tr),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showLogDialog(
    BuildContext context,
    FarmRepository repository,
  ) async {
    final title = TextEditingController();
    final notes = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_log'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(labelText: 'title'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notes,
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
              if (_farmId != null && title.text.trim().isNotEmpty) {
                await repository.createLog(
                  _farmId!,
                  type: 'note',
                  title: title.text.trim(),
                  notes: notes.text.trim(),
                );
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

class HarvestView extends StatelessWidget {
  const HarvestView({super.key});
  @override
  Widget build(BuildContext context) {
    final repository = Get.find<FarmRepository>();
    final future = _farmId == null
        ? Future.value(const RepositoryState<List<HarvestRecord>>.empty())
        : repository.getHarvests(_farmId!);
    return Scaffold(
      appBar: AppBar(title: Text('harvest'.tr)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addHarvest(context, repository),
        icon: const Icon(Icons.add),
        label: Text('add_harvest'.tr),
      ),
      body: FutureBuilder<RepositoryState<List<HarvestRecord>>>(
        future: future,
        builder: (context, snapshot) =>
            RepositoryStateView<List<HarvestRecord>>(
          state: snapshot.data ?? const RepositoryState.loading(),
          onRetry: () => Get.offNamed(Routes.HARVEST),
          emptyMessageKey: 'no_harvest_records',
          dataBuilder: (items) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, index) => ListTile(
              leading: const Icon(Icons.agriculture, color: AppColors.success),
              title: Text('${items[index].quantity} ${items[index].unit}'),
              subtitle: Text(items[index].grade ?? 'ungraded'.tr),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addHarvest(
    BuildContext context,
    FarmRepository repository,
  ) async {
    final quantity = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add_harvest'.tr),
        content: TextField(
          controller: quantity,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'quantity_kg'.tr),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(quantity.text);
              if (_farmId != null && value != null) {
                await repository.createHarvest(
                  _farmId!,
                  quantity: value,
                  unit: 'kg',
                );
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

class AssistantView extends StatefulWidget {
  const AssistantView({super.key});
  @override
  State<AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<AssistantView> {
  final repository = Get.find<FarmRepository>();
  final input = TextEditingController();
  String? answer;
  bool loading = false;

  Future<void> ask() async {
    if (_farmId == null || input.text.trim().isEmpty) return;
    setState(() => loading = true);
    final response = await repository.askAssistant(_farmId!, input.text.trim());
    setState(() {
      loading = false;
      answer = response.data ?? response.message ?? 'assistant_unavailable'.tr;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('ai_assistant'.tr)),
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFFE2F5E7),
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 42,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 12),
              Text('assistant_read_only'.tr, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              if (answer != null)
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(answer!),
                    ),
                  ),
                ),
              const Spacer(),
              TextField(
                controller: input,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'ask_farm_question'.tr,
                  suffixIcon: loading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: ask,
                          icon: const Icon(Icons.send),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
}

class HistoryHubView extends StatelessWidget {
  const HistoryHubView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('history'.tr)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _HistoryLink('control_history', Icons.settings_remote,
                Routes.CONTROL_HISTORY),
            _HistoryLink('farm_log', Icons.menu_book, Routes.FARM_LOG),
            _HistoryLink('usage_cost', Icons.paid_outlined, Routes.USAGE),
            _HistoryLink(
                'ripeness', Icons.camera_alt_outlined, Routes.RIPENESS),
            _HistoryLink('harvest', Icons.agriculture, Routes.HARVEST),
          ],
        ),
      );
}

class _HistoryLink extends StatelessWidget {
  const _HistoryLink(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: ListTile(
          onTap: () => Get.toNamed(route),
          leading: Icon(icon, color: AppColors.primary),
          title: Text(label.tr),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
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
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(body),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/prototype/prototype_models.dart';
import 'package:lntb_app/core/repositories/demo_prototype_repository.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class MultiZoneControlView extends StatefulWidget {
  const MultiZoneControlView({required this.demo, super.key});

  final DemoPrototypeRepository demo;

  @override
  State<MultiZoneControlView> createState() => _MultiZoneControlViewState();
}

class _MultiZoneControlViewState extends State<MultiZoneControlView> {
  ActuatorKind? action;
  final selectedZoneIds = <String>{};
  int durationMinutes = 10;
  bool sending = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('control_several_zones'.tr)),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'what_do_you_want'.tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                _ActionChoice(
                  selected: action,
                  onSelected: (value) => setState(() {
                    action = value;
                    selectedZoneIds.clear();
                  }),
                ),
                if (action != null) ...[
                  const SizedBox(height: 22),
                  Text(
                    'choose_zones'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...widget.demo.zones.map(_zoneChoice),
                  if (action == ActuatorKind.pump) ...[
                    const SizedBox(height: 16),
                    Text(
                      'how_long_water'.tr,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<int>(
                      segments: [
                        for (final minutes in const [5, 10, 15])
                          ButtonSegment(
                            value: minutes,
                            label: Text('$minutes ${'minutes'.tr}'),
                          ),
                      ],
                      selected: {durationMinutes},
                      onSelectionChanged: (value) {
                        setState(() => durationMinutes = value.first);
                      },
                    ),
                  ],
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: selectedZoneIds.isEmpty || sending
                        ? null
                        : _reviewAndSend,
                    child: Text('review_and_start'.tr),
                  ),
                ],
              ],
            ),
          ),
        ),
      );

  Widget _zoneChoice(FarmZone zone) {
    final disabled = widget.demo.controlsBlocked;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: selectedZoneIds.contains(zone.id),
        onChanged: disabled
            ? null
            : (checked) => setState(() {
                  if (checked == true) {
                    selectedZoneIds.add(zone.id);
                  } else {
                    selectedZoneIds.remove(zone.id);
                  }
                }),
        title: Text(zone.name),
        subtitle: disabled
            ? Text(
                widget.demo.blockingReason.tr,
                style: const TextStyle(color: AppColors.error),
              )
            : Text('ready'.tr),
        secondary: Icon(
          disabled ? Icons.block : Icons.eco_outlined,
          color: disabled ? AppColors.error : AppColors.primary,
        ),
      ),
    );
  }

  Future<void> _reviewAndSend() async {
    final selected = widget.demo.zones
        .where((zone) => selectedZoneIds.contains(zone.id))
        .toList();
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'check_before_start'.tr,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(_actionLabel(action!)),
              if (action == ActuatorKind.pump)
                Text('$durationMinutes ${'minutes'.tr}'),
              const SizedBox(height: 10),
              ...selected.map(
                (zone) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.primary,
                  ),
                  title: Text(zone.name),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('cancel'.tr),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('start'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true) return;
    setState(() => sending = true);
    final failed = <FarmZone>[];
    for (final zone in selected) {
      final result = await widget.demo.runZoneCommand(
        zone,
        action!,
        true,
        durationMinutes: action == ActuatorKind.pump ? durationMinutes : null,
      );
      if (result == ActuatorState.failed) failed.add(zone);
    }
    if (!mounted) return;
    setState(() {
      sending = false;
      selectedZoneIds
        ..clear()
        ..addAll(failed.map((zone) => zone.id));
    });
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('result'.tr),
        content: Text(
          failed.isEmpty ? 'selected_zones_started'.tr : 'some_zones_failed'.tr,
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text('done'.tr),
          ),
        ],
      ),
    );
  }

  String _actionLabel(ActuatorKind value) => switch (value) {
        ActuatorKind.pump => 'start_watering'.tr,
        ActuatorKind.fan => 'start_fan'.tr,
        ActuatorKind.roof => 'open_roof'.tr,
        ActuatorKind.camera => 'take_photo'.tr,
      };
}

class _ActionChoice extends StatelessWidget {
  const _ActionChoice({
    required this.selected,
    required this.onSelected,
  });

  final ActuatorKind? selected;
  final ValueChanged<ActuatorKind> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _choice(ActuatorKind.pump, Icons.water_drop_outlined, 'water'.tr),
          _choice(ActuatorKind.fan, Icons.air, 'fan'.tr),
          _choice(ActuatorKind.roof, Icons.roofing_outlined, 'roof'.tr),
          _choice(ActuatorKind.camera, Icons.camera_alt_outlined, 'camera'.tr),
        ],
      );

  Widget _choice(ActuatorKind value, IconData icon, String label) => ChoiceChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        selected: selected == value,
        onSelected: (_) => onSelected(value),
      );
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/core/theme/app_typography.dart';

class HomeViewFarmHealthCard extends StatelessWidget {
  const HomeViewFarmHealthCard({
    super.key,
    required this.connected,
    required this.needsAttention,
    required this.soilValue,
    required this.temperatureValue,
    required this.humidityValue,
  });

  final bool connected;
  final bool needsAttention;
  final double? soilValue;
  final double? temperatureValue;
  final double? humidityValue;

  @override
  Widget build(BuildContext context) {
    final statusLabel = !connected
        ? 'farm_offline'.tr
        : needsAttention
            ? 'needs_attention'.tr
            : 'farm_connected'.tr;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: .18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  connected
                      ? Icons.energy_savings_leaf_rounded
                      : Icons.cloud_off_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'today_farm_status'.tr,
                      style: const TextStyle(
                        color: Color(0xFFD8FFE5),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusLabel,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: !connected
                      ? const Color(0xFFFFA4A4)
                      : needsAttention
                          ? const Color(0xFFFFD38A)
                          : const Color(0xFF8EF0AE),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: .4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: .16),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroMetric(
                label: 'soil_1'.tr,
                value: _reading(soilValue, '%', 0),
              ),
              const _HeroDivider(),
              _HeroMetric(
                label: 'temperature'.tr,
                value: _reading(temperatureValue, '°', 1),
              ),
              const _HeroDivider(),
              _HeroMetric(
                label: 'humidity'.tr,
                value: _reading(humidityValue, '%', 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _reading(double? value, String unit, int decimals) =>
      value == null ? '—' : '${value.toStringAsFixed(decimals)}$unit';
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTypography.sensorValue.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFCEF3DA),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
}

class _HeroDivider extends StatelessWidget {
  const _HeroDivider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 38,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: Colors.white.withValues(alpha: .17),
      );
}

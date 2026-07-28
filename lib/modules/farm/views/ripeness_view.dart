import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_typography.dart';
import 'package:lntb_app/modules/farm/controllers/ripeness_controller.dart';

class RipenessView extends GetView<RipenessController> {
  const RipenessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ripeness'.tr)),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return Center(child: Text('no_ripeness_results'.tr));
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .78,
            ),
            itemCount: controller.items.length,
            itemBuilder: (_, index) {
              final item = controller.items[index];
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
                            style: AppTypography.sensorValue.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

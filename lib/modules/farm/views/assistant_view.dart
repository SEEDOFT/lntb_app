import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/theme/app_colors.dart';
import 'package:lntb_app/modules/farm/controllers/assistant_controller.dart';

class AssistantView extends GetView<AssistantController> {
  const AssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    final inputController = TextEditingController();
    return Scaffold(
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
            Obx(() {
              if (controller.answer.value == null) {
                return const SizedBox.shrink();
              }
              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(controller.answer.value!),
                  ),
                ),
              );
            }),
            const Spacer(),
            Obx(
              () => TextField(
                controller: inputController,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'ask_farm_question'.tr,
                  suffixIcon: controller.isLoading.value
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: () {
                            controller.ask(inputController.text);
                            inputController.clear();
                          },
                          icon: const Icon(Icons.send),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

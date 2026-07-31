import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/farm_dashboard_models.dart';
import 'package:lntb_app/core/repositories/assistant_repository.dart';
import 'package:lntb_app/modules/home/controllers/home_controller.dart';

class AssistantMessage {
  const AssistantMessage({required this.text, required this.fromUser});

  final String text;
  final bool fromUser;
}

class AssistantController extends GetxController {
  AssistantController({AssistantRepository? repository})
      : repository = repository ?? Get.find<AssistantRepository>();

  final AssistantRepository repository;
  final input = TextEditingController();
  final messages = <AssistantMessage>[].obs;
  final isSending = false.obs;
  final error = RxnString();
  late final FarmSummary farm;

  @override
  void onInit() {
    super.onInit();
    farm = Get.arguments as FarmSummary;
    final summary = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>().dashboard.value?.assistant
        : null;
    if (summary != null && summary.answer.isNotEmpty) {
      messages.addAll([
        AssistantMessage(text: summary.question, fromUser: true),
        AssistantMessage(text: summary.answer, fromUser: false),
      ]);
    }
  }

  Future<void> send() async {
    final question = input.text.trim();
    if (question.isEmpty || isSending.value) return;
    input.clear();
    messages.add(AssistantMessage(text: question, fromUser: true));
    isSending.value = true;
    error.value = null;
    try {
      final answer = await repository.ask(farmId: farm.id, question: question);
      messages.add(AssistantMessage(text: answer, fromUser: false));
      if (Get.isRegistered<HomeController>()) {
        unawaited(Get.find<HomeController>().load());
      }
    } catch (_) {
      error.value = 'assistant_unavailable'.tr;
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    input.dispose();
    super.onClose();
  }
}

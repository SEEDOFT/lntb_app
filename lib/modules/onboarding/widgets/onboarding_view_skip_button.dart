import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text('skip'.tr),
          ),
        ),
      );
}

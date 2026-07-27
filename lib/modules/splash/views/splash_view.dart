import 'package:flutter/material.dart';
import 'package:lntb_app/core/constants/app_assets.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF0758B9),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.splashSmartFarm,
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Color(0x55002058), Colors.transparent],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 42, 28, 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 18),
                        ],
                      ),
                      child: Image.asset(
                        AppAssets.logo,
                        width: 74,
                        height: 74,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'LNTB IoT',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'ឆ្លាតវៃជាមួយកសិកម្មទំនើប',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Smart Agriculture, Better Life',
                      style: TextStyle(fontSize: 12, color: Color(0xFFDDEEFF)),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'កំពុងរៀបចំ...',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 86,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

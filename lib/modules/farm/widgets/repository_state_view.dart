import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lntb_app/core/models/repository_state.dart';
import 'package:lntb_app/core/theme/app_colors.dart';

class RepositoryStateView<T> extends StatelessWidget {
  const RepositoryStateView({
    super.key,
    required this.state,
    required this.dataBuilder,
    required this.onRetry,
    this.emptyMessageKey = 'farm_data_empty',
  });

  final RepositoryState<T> state;
  final Widget Function(T data) dataBuilder;
  final VoidCallback onRetry;
  final String emptyMessageKey;

  @override
  Widget build(BuildContext context) {
    if (state.type == RepositoryStateType.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      );
    }
    if (state.data != null) return dataBuilder(state.data as T);

    final unavailable = state.type == RepositoryStateType.unavailable;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                unavailable
                    ? Icons.cloud_off_outlined
                    : Icons.inbox_outlined,
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              unavailable ? 'feature_unavailable'.tr : emptyMessageKey.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (state.message != null) ...[
              const SizedBox(height: 8),
              Text(
                state.message!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('try_again'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

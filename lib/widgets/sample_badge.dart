import 'package:flutter/material.dart';

import 'package:uc_campus/core/app_spacing.dart';

/// 실제 학교 정보가 아닌 항목에 붙이는 작은 샘플 표시다.
class SampleBadge extends StatelessWidget {
  const SampleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          '샘플',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

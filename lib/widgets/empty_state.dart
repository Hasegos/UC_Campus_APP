import 'package:flutter/material.dart';

import 'package:uc_campus/core/app_spacing.dart';

/// 빈 목록의 아이콘, 안내 문구, 선택 동작을 함께 보여준다.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  }) : assert(
         (actionLabel == null && onAction == null) ||
             (actionLabel != null && onAction != null),
       );

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(
                icon,
                size: AppSpacing.xl,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(message, textAlign: TextAlign.center),
            if (label != null) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.tonal(onPressed: onAction, child: Text(label)),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// 섹션 제목과 선택적인 이동 버튼을 표시한다.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (label != null) TextButton(onPressed: onAction, child: Text(label)),
      ],
    );
  }
}

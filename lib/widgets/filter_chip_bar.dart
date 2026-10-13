import 'package:flutter/material.dart';

import 'package:uc_campus/core/app_spacing.dart';

/// 전체 선택과 단일 선택 필터를 가로 스크롤 칩으로 표시한다.
class FilterChipBar<T> extends StatelessWidget {
  const FilterChipBar({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
  });

  final List<T> options;
  final String Function(T) labelOf;
  final T? selected;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('전체'),
            selected: selected == null,
            onSelected: (_) => onSelected(null),
          ),
          for (final option in options) ...[
            const SizedBox(width: AppSpacing.sm),
            FilterChip(
              label: Text(labelOf(option)),
              selected: selected == option,
              onSelected: (_) => onSelected(option),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// 정렬 선택 메뉴를 표시하고 현재 선택에 체크 표시를 붙인다.
class SortMenuButton<T> extends StatelessWidget {
  const SortMenuButton({
    super.key,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
  });

  final List<T> options;
  final String Function(T) labelOf;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: const Icon(Icons.sort),
      tooltip: '정렬',
      onSelected: onSelected,
      itemBuilder: (_) => [
        for (final option in options)
          CheckedPopupMenuItem<T>(
            value: option,
            checked: option == selected,
            child: Text(labelOf(option)),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// 선택 상태에 맞는 아이콘과 동작 설명을 표시한다.
class ToggleIconButton extends StatelessWidget {
  const ToggleIconButton({
    super.key,
    required this.isOn,
    required this.onIcon,
    required this.offIcon,
    required this.onTooltip,
    required this.offTooltip,
    required this.onPressed,
  });

  final bool isOn;
  final IconData onIcon;
  final IconData offIcon;
  final String onTooltip;
  final String offTooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isOn ? onIcon : offIcon),
      tooltip: isOn ? onTooltip : offTooltip,
      onPressed: onPressed,
    );
  }
}

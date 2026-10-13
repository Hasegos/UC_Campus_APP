import 'package:flutter/material.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/widgets/sample_badge.dart';
import 'package:uc_campus/widgets/toggle_icon_button.dart';

/// 학과와 찜 상태를 표시하고 이동·찜 동작을 콜백으로 전달한다.
class DepartmentTile extends StatelessWidget {
  const DepartmentTile({
    super.key,
    required this.department,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Department department;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(department.name),
        subtitle: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(label: Text(department.track.label)),
            if (department.isSample) const SampleBadge(),
          ],
        ),
        onTap: onTap,
        trailing: ToggleIconButton(
          isOn: isFavorite,
          onIcon: Icons.favorite,
          offIcon: Icons.favorite_border,
          onTooltip: '찜 해제',
          offTooltip: '찜하기',
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}

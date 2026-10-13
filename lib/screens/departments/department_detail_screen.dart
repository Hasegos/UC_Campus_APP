import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/sample_badge.dart';
import 'package:uc_campus/widgets/toggle_icon_button.dart';

/// 전달받은 학과 정보와 공유 찜 상태를 표시한다.
class DepartmentDetailScreen extends StatelessWidget {
  const DepartmentDetailScreen({super.key, required this.department});

  final Department department;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select(
      (AppState state) => state.isFavorite(department.id),
    );
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(department.name),
        actions: [
          ToggleIconButton(
            isOn: isFavorite,
            onIcon: Icons.favorite,
            offIcon: Icons.favorite_border,
            onTooltip: '찜 해제',
            offTooltip: '찜하기',
            onPressed: () =>
                context.read<AppState>().toggleFavorite(department.id),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Chip(label: Text(department.track.label)),
              if (department.isSample) const SampleBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(department.summary, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          _KeywordSection(title: '교육과정', keywords: department.curriculum),
          const SizedBox(height: AppSpacing.lg),
          _KeywordSection(title: '진로', keywords: department.careers),
          const SizedBox(height: AppSpacing.lg),
          Text('연락처', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(department.phone ?? '정보 없음'),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () =>
                context.read<AppState>().toggleFavorite(department.id),
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            label: Text(isFavorite ? '찜 해제' : '찜하기'),
          ),
        ],
      ),
    );
  }
}

/// 상세 화면의 키워드 섹션과 정보 없음 문구를 구성한다.
class _KeywordSection extends StatelessWidget {
  const _KeywordSection({required this.title, required this.keywords});

  final String title;
  final List<String> keywords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (keywords.isEmpty)
          const Text('정보 없음')
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final keyword in keywords) Chip(label: Text(keyword)),
            ],
          ),
      ],
    );
  }
}

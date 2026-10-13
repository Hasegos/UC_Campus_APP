import 'package:flutter/material.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/core/date_format.dart';
import 'package:uc_campus/models/schedule_event.dart';
import 'package:uc_campus/widgets/sample_badge.dart';

/// 기간·제목·카테고리와 샘플 여부를 표시하는 일정 카드다.
class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event});
  final ScheduleEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formatRange(event.startDate, event.endDate)),
            const SizedBox(height: AppSpacing.sm),
            Text(event.title, style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(label: Text(event.category.label)),
                if (event.isSample) const SampleBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

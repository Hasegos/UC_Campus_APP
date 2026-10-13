import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/core/date_format.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/models/schedule_event.dart';
import 'package:uc_campus/widgets/empty_state.dart';
import 'package:uc_campus/widgets/event_tile.dart';
import 'package:uc_campus/widgets/filter_chip_bar.dart';

/// 선택한 달과 카테고리의 일정을 표시한다.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, this.now});
  final DateTime? now;
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _month;
  ScheduleCategory? _category;

  @override
  void initState() {
    super.initState();
    final today = widget.now ?? DateTime.now();
    _month = DateTime(today.year, today.month);
  }

  @override
  Widget build(BuildContext context) {
    final events = context.read<CampusRepository>().eventsInMonth(
      _month,
      category: _category,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('일정')),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: '이전 달',
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _month = addMonths(_month, -1)),
              ),
              Expanded(
                child: Text(
                  formatYearMonth(_month),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: '다음 달',
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _month = addMonths(_month, 1)),
              ),
              TextButton(
                onPressed: () {
                  final today = widget.now ?? DateTime.now();
                  setState(() => _month = DateTime(today.year, today.month));
                },
                child: const Text('오늘'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilterChipBar<ScheduleCategory>(
              options: ScheduleCategory.values,
              labelOf: (category) => category.label,
              selected: _category,
              onSelected: (category) => setState(() => _category = category),
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? const EmptyState(
                    icon: Icons.event_busy,
                    message: '이 달에는 일정이 없어요.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    itemCount: events.length,
                    itemBuilder: (_, index) => EventTile(event: events[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

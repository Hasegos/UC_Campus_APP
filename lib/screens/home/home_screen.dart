import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/core/date_format.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/models/schedule_event.dart';
import 'package:uc_campus/screens/open_detail.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/empty_state.dart';
import 'package:uc_campus/widgets/event_tile.dart';
import 'package:uc_campus/widgets/notice_tile.dart';
import 'package:uc_campus/widgets/section_header.dart';

/// 최근 공지·다가오는 일정·찜 학과와 탭 이동을 모은 홈 화면이다.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSelectTab, this.now});
  final ValueChanged<int> onSelectTab;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<CampusRepository>();
    final name = context.select((AppState state) => state.userName);
    final favorites = context.select((AppState state) => state.favoriteDeptIds);
    final readIds = context.select((AppState state) => state.readNoticeIds);
    final bookmarks = context.select(
      (AppState state) => state.bookmarkedNoticeIds,
    );
    final today = dateOnly(now ?? DateTime.now());
    final featured = repository.featuredEvent(today);
    final notices = repository.recentNotices();
    final events = repository.upcomingEvents(today);
    return Scaffold(
      appBar: AppBar(title: const Text('UCheck 캠퍼스')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            name == null ? 'UCheck 캠퍼스에 오신 걸 환영해요' : '안녕하세요, $name님',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          if (featured != null) _DdayCard(event: featured, today: today),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (label, icon, index) in [
                ('학과', Icons.school, 1),
                ('공지', Icons.campaign, 2),
                ('일정', Icons.calendar_month, 3),
                ('마이', Icons.person, 4),
              ])
                FilledButton.tonalIcon(
                  onPressed: () => onSelectTab(index),
                  icon: Icon(icon),
                  label: Text(label),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: '최근 공지',
            actionLabel: '더보기',
            onAction: () => onSelectTab(2),
          ),
          if (notices.isEmpty) const Text('표시할 공지가 없어요.'),
          for (final notice in notices)
            NoticeTile(
              notice: notice,
              isRead: readIds.contains(notice.id),
              isBookmarked: bookmarks.contains(notice.id),
              onTap: () => openNotice(context, notice),
              onToggleBookmark: () =>
                  context.read<AppState>().toggleBookmark(notice.id),
            ),
          const SizedBox(height: AppSpacing.lg),
          SectionHeader(
            title: '다가오는 일정',
            actionLabel: '더보기',
            onAction: () => onSelectTab(3),
          ),
          if (events.isEmpty) const Text('예정된 일정이 없어요.'),
          for (final event in events) EventTile(event: event),
          const SizedBox(height: AppSpacing.lg),
          const SectionHeader(title: '찜한 학과'),
          if (favorites.isEmpty)
            const EmptyState(
              icon: Icons.favorite_border,
              message: '학과 탭에서 마음에 드는 학과를 찜해 보세요.',
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final department in repository.departments.where(
                  (item) => favorites.contains(item.id),
                ))
                  ActionChip(
                    label: Text(department.name),
                    onPressed: () => openDepartment(context, department),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// 확인된 접수 일정의 기간과 현재 D-day를 표시한다.
class _DdayCard extends StatelessWidget {
  const _DdayCard({required this.event, required this.today});
  final ScheduleEvent event;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: Theme.of(context).textTheme.titleMedium),
            Text(
              dDayLabel(event.startDate, event.endDate, today),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${formatDate(event.startDate)} ~ ${formatDate(event.endDate)}',
            ),
          ],
        ),
      ),
    );
  }
}

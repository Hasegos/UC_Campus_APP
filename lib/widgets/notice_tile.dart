import 'package:flutter/material.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/core/date_format.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/widgets/sample_badge.dart';
import 'package:uc_campus/widgets/toggle_icon_button.dart';

/// 공지 제목·게시일·읽음·북마크를 표시하고 동작을 콜백으로 전달한다.
class NoticeTile extends StatelessWidget {
  const NoticeTile({
    super.key,
    required this.notice,
    required this.isRead,
    required this.isBookmarked,
    required this.onTap,
    required this.onToggleBookmark,
  });
  final Notice notice;
  final bool isRead;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isRead)
              Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.sm,
                  top: AppSpacing.xs,
                ),
                child: Icon(
                  Icons.circle,
                  size: AppSpacing.sm,
                  semanticLabel: '안 읽음',
                ),
              ),
            Expanded(
              child: Text(
                notice.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${notice.category.label} · ${notice.id == 'notice_024' ? '게시일 미확인' : formatDate(notice.postedAt)}',
            ),
            if (notice.isSample) const SampleBadge(),
          ],
        ),
        trailing: ToggleIconButton(
          isOn: isBookmarked,
          onIcon: Icons.bookmark,
          offIcon: Icons.bookmark_border,
          onTooltip: '북마크 해제',
          offTooltip: '북마크',
          onPressed: onToggleBookmark,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/core/date_format.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/sample_badge.dart';
import 'package:uc_campus/widgets/toggle_icon_button.dart';

/// 공지 본문과 북마크·개인 메모를 표시한다.
class NoticeDetailScreen extends StatefulWidget {
  const NoticeDetailScreen({super.key, required this.notice});
  final Notice notice;

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  late final TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(
      text: context.read<AppState>().memoFor(widget.notice.id) ?? '',
    );
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  /// 입력 메모를 공유 상태에 저장하고 완료 메시지를 표시한다.
  void _saveMemo() {
    context.read<AppState>().setMemo(widget.notice.id, _memoController.text);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('저장했어요')));
  }

  @override
  Widget build(BuildContext context) {
    final notice = widget.notice;
    final bookmarked = context.select(
      (AppState state) => state.isBookmarked(notice.id),
    );
    final hasMemo = context.select(
      (AppState state) => state.memoFor(notice.id) != null,
    );
    final source = notice.sourceUrl;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('공지'),
        actions: [
          ToggleIconButton(
            isOn: bookmarked,
            onIcon: Icons.bookmark,
            offIcon: Icons.bookmark_border,
            onTooltip: '북마크 해제',
            offTooltip: '북마크',
            onPressed: () => context.read<AppState>().toggleBookmark(notice.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Chip(label: Text(notice.category.label)),
                if (notice.isSample) const SampleBadge(),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(notice.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              notice.id == 'notice_024'
                  ? '게시일 미확인'
                  : formatDate(notice.postedAt),
            ),
            const Divider(),
            SelectableText(notice.body, style: theme.textTheme.bodyLarge),
            if (source != null) ...[
              const SizedBox(height: AppSpacing.md),
              SelectableText(source),
            ],
            const SizedBox(height: AppSpacing.lg),
            Text('내 메모', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _memoController,
              minLines: 3,
              maxLines: null,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(
                labelText: '내 메모',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                FilledButton(onPressed: _saveMemo, child: const Text('저장')),
                if (hasMemo)
                  TextButton(
                    onPressed: () {
                      context.read<AppState>().setMemo(notice.id, '');
                      _memoController.clear();
                    },
                    child: const Text('삭제'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

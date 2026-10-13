import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/data/sort_options.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/screens/open_detail.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/app_search_field.dart';
import 'package:uc_campus/widgets/empty_state.dart';
import 'package:uc_campus/widgets/filter_chip_bar.dart';
import 'package:uc_campus/widgets/notice_tile.dart';
import 'package:uc_campus/widgets/sort_menu_button.dart';

/// 공지 검색 조건을 화면에 보관하고 읽음·북마크를 공유한다.
class NoticeListScreen extends StatefulWidget {
  const NoticeListScreen({super.key});
  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  NoticeCategory? _category;
  NoticeSort _sort = NoticeSort.newest;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 검색 조건 전체를 기본값으로 되돌린다.
  void _reset() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = null;
      _sort = NoticeSort.newest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final readIds = context.select((AppState state) => state.readNoticeIds);
    final bookmarks = context.select(
      (AppState state) => state.bookmarkedNoticeIds,
    );
    final notices = context.read<CampusRepository>().searchNotices(
      query: _query,
      category: _category,
      sort: _sort,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('공지')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AppSearchField(
              controller: _searchController,
              hintText: '공지 검색',
              onChanged: (query) => setState(() => _query = query),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilterChipBar<NoticeCategory>(
              options: NoticeCategory.values,
              labelOf: (category) => category.label,
              selected: _category,
              onSelected: (category) => setState(() => _category = category),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(child: Text('${notices.length}개 공지')),
                SortMenuButton<NoticeSort>(
                  options: NoticeSort.values,
                  labelOf: (sort) => sort.label,
                  selected: _sort,
                  onSelected: (sort) => setState(() => _sort = sort),
                ),
              ],
            ),
          ),
          Expanded(
            child: notices.isEmpty
                ? SingleChildScrollView(
                    child: EmptyState(
                      icon: Icons.search_off,
                      message: '조건에 맞는 공지가 없어요.',
                      actionLabel: '필터 초기화',
                      onAction: _reset,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      final notice = notices[index];
                      return NoticeTile(
                        key: ValueKey(notice.id),
                        notice: notice,
                        isRead: readIds.contains(notice.id),
                        isBookmarked: bookmarks.contains(notice.id),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          openNotice(context, notice);
                        },
                        onToggleBookmark: () =>
                            context.read<AppState>().toggleBookmark(notice.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

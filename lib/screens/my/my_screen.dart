import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/screens/open_detail.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/department_tile.dart';
import 'package:uc_campus/widgets/empty_state.dart';
import 'package:uc_campus/widgets/notice_tile.dart';
import 'package:uc_campus/widgets/section_header.dart';

/// 가짜 로그인·테마·샘플 안내와 사용자가 모은 항목을 표시한다.
class MyScreen extends StatefulWidget {
  const MyScreen({super.key, required this.onSelectTab});
  final ValueChanged<int> onSelectTab;

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 비어 있지 않은 로그인 값을 확인하고 이름만 공유 상태에 저장한다.
  void _login() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<AppState>().login(_nameController.text);
    _nameController.clear();
    _passwordController.clear();
    FocusScope.of(context).unfocus();
  }

  /// 입력값이 공백이면 필드 오류 메시지를 반환한다.
  String? _validate(String? value) =>
      value == null || value.trim().isEmpty ? '입력해 주세요' : null;

  @override
  Widget build(BuildContext context) {
    final name = context.select((AppState state) => state.userName);
    final mode = context.select((AppState state) => state.themeMode);
    return Scaffold(
      appBar: AppBar(title: const Text('마이')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: name == null
                  ? Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: _validate,
                            textInputAction: TextInputAction.next,
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            decoration: const InputDecoration(labelText: '아이디'),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: _validate,
                            obscureText: true,
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            decoration: const InputDecoration(
                              labelText: '비밀번호',
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          FilledButton(
                            onPressed: _login,
                            child: const Text('로그인'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        CircleAvatar(
                          child: Text(String.fromCharCode(name.runes.first)),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text('$name님'),
                        OutlinedButton(
                          onPressed: () => context.read<AppState>().logout(),
                          child: const Text('로그아웃'),
                        ),
                      ],
                    ),
            ),
          ),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text(
                '이 앱의 공지, 일정, 학과 소개는 학습용 샘플 데이터예요. 학교의 실제 정보가 아니에요. 실제 정보와 같은 것은 학과 이름과 2026학년도 수시 2차 접수 기간(2026-11-11 ~ 2026-11-25)뿐이에요.',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('화면 설정', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, label: Text('시스템')),
              ButtonSegment(value: ThemeMode.light, label: Text('라이트')),
              ButtonSegment(value: ThemeMode.dark, label: Text('다크')),
            ],
            selected: {mode},
            onSelectionChanged: (selection) =>
                context.read<AppState>().setThemeMode(selection.first),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Collections(onSelectTab: widget.onSelectTab),
        ],
      ),
    );
  }
}

/// 공유 상태의 id를 저장소 객체로 찾아 찜·북마크·메모 목록을 표시한다.
class _Collections extends StatelessWidget {
  const _Collections({required this.onSelectTab});
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<CampusRepository>();
    final favorites = context.select((AppState state) => state.favoriteDeptIds);
    final bookmarks = context.select(
      (AppState state) => state.bookmarkedNoticeIds,
    );
    final readIds = context.select((AppState state) => state.readNoticeIds);
    final memos = context.select((AppState state) => state.memos);
    final departments = favorites
        .map(repository.departmentById)
        .whereType<Department>()
        .toList();
    final notices = bookmarks
        .map(repository.noticeById)
        .whereType<Notice>()
        .toList();
    final memoNotices = memos.keys
        .map(repository.noticeById)
        .whereType<Notice>()
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: '찜한 학과 (${departments.length})'),
        if (departments.isEmpty)
          EmptyState(
            icon: Icons.favorite_border,
            message: '찜한 학과가 없어요.',
            actionLabel: '학과 보러 가기',
            onAction: () => onSelectTab(1),
          ),
        for (final department in departments)
          DepartmentTile(
            department: department,
            isFavorite: true,
            onTap: () => openDepartment(context, department),
            onToggleFavorite: () =>
                context.read<AppState>().toggleFavorite(department.id),
          ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: '북마크한 공지 (${notices.length})'),
        if (notices.isEmpty)
          EmptyState(
            icon: Icons.bookmark_border,
            message: '북마크한 공지가 없어요.',
            actionLabel: '공지 보러 가기',
            onAction: () => onSelectTab(2),
          ),
        for (final notice in notices)
          NoticeTile(
            notice: notice,
            isRead: readIds.contains(notice.id),
            isBookmarked: true,
            onTap: () => openNotice(context, notice),
            onToggleBookmark: () =>
                context.read<AppState>().toggleBookmark(notice.id),
          ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: '내 메모 (${memoNotices.length})'),
        if (memoNotices.isEmpty)
          const EmptyState(icon: Icons.edit_note, message: '작성한 메모가 없어요.'),
        for (final notice in memoNotices)
          _MemoTile(
            notice: notice,
            memo: memos[notice.id] ?? '',
            onTap: () => openNotice(context, notice),
          ),
      ],
    );
  }
}

/// 공지 제목과 메모 두 줄을 표시하고 상세 화면으로 이동한다.
class _MemoTile extends StatelessWidget {
  const _MemoTile({
    required this.notice,
    required this.memo,
    required this.onTap,
  });
  final Notice notice;
  final String memo;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(notice.title),
        subtitle: Text(memo, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
  }
}

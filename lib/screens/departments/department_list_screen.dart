import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/data/sort_options.dart';
import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/screens/open_detail.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/app_search_field.dart';
import 'package:uc_campus/widgets/department_tile.dart';
import 'package:uc_campus/widgets/empty_state.dart';
import 'package:uc_campus/widgets/filter_chip_bar.dart';
import 'package:uc_campus/widgets/sort_menu_button.dart';

/// 화면 내부 검색 조건과 공유 찜 상태로 학과 목록을 구성한다.
class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  DepartmentTrack? _track;
  DepartmentSort _sort = DepartmentSort.defaultOrder;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// 검색어·계열·정렬을 한 번에 기본값으로 되돌린다.
  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _track = null;
      _sort = DepartmentSort.defaultOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.select(
      (AppState state) => state.favoriteDeptIds,
    );
    final departments = context.read<CampusRepository>().searchDepartments(
      query: _query,
      track: _track,
      sort: _sort,
      favoriteIds: favoriteIds,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('학과')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AppSearchField(
              controller: _searchController,
              hintText: '학과 검색',
              onChanged: (query) => setState(() => _query = query),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilterChipBar<DepartmentTrack>(
              options: DepartmentTrack.values,
              labelOf: (track) => track.label,
              selected: _track,
              onSelected: (track) => setState(() => _track = track),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(child: Text('${departments.length}개 학과')),
                SortMenuButton<DepartmentSort>(
                  options: DepartmentSort.values,
                  labelOf: (sort) => sort.label,
                  selected: _sort,
                  onSelected: (sort) => setState(() => _sort = sort),
                ),
              ],
            ),
          ),
          Expanded(
            child: departments.isEmpty
                ? SingleChildScrollView(
                    child: EmptyState(
                      icon: Icons.search_off,
                      message: '조건에 맞는 학과가 없어요.',
                      actionLabel: '필터 초기화',
                      onAction: _resetFilters,
                    ),
                  )
                : ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      0,
                      AppSpacing.sm,
                      AppSpacing.md,
                    ),
                    itemCount: departments.length,
                    itemBuilder: (context, index) {
                      final department = departments[index];
                      return DepartmentTile(
                        key: ValueKey(department.id),
                        department: department,
                        isFavorite: favoriteIds.contains(department.id),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          openDepartment(context, department);
                        },
                        onToggleFavorite: () => context
                            .read<AppState>()
                            .toggleFavorite(department.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/services.dart';

import 'package:uc_campus/data/sort_options.dart';
import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/models/json_parse.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/models/schedule_event.dart';

/// 앱 에셋의 학과, 공지, 일정을 메모리에 보관하는 읽기 전용 저장소다.
class CampusRepository {
  CampusRepository._({
    required List<Department> departments,
    required List<Notice> notices,
    required List<ScheduleEvent> events,
  }) : departments = List.unmodifiable(departments),
       notices = List.unmodifiable(notices),
       events = List.unmodifiable(events);

  final List<Department> departments;
  final List<Notice> notices;
  final List<ScheduleEvent> events;

  /// 이름과 소개를 검색하고 계열과 [sort]에 따라 새 학과 목록을 돌려준다.
  /// 찜 우선 정렬에서도 각 묶음의 원래 JSON 순서를 유지한다.
  List<Department> searchDepartments({
    String query = '',
    DepartmentTrack? track,
    DepartmentSort sort = DepartmentSort.defaultOrder,
    Set<String> favoriteIds = const {},
  }) {
    final keyword = query.trim().toLowerCase();
    final result = departments.where((department) {
      final matchesQuery =
          keyword.isEmpty ||
          department.name.toLowerCase().contains(keyword) ||
          department.summary.toLowerCase().contains(keyword);
      return matchesQuery && (track == null || department.track == track);
    }).toList();

    switch (sort) {
      case DepartmentSort.defaultOrder:
        return result;
      case DepartmentSort.nameAsc:
        return result..sort((left, right) => left.name.compareTo(right.name));
      case DepartmentSort.favoritesFirst:
        return [
          ...result.where((item) => favoriteIds.contains(item.id)),
          ...result.where((item) => !favoriteIds.contains(item.id)),
        ];
    }
  }

  /// 앱 에셋 세 개를 읽고 스키마와 데이터 관계를 검증한다.
  static Future<CampusRepository> load({AssetBundle? bundle}) async {
    final assetBundle = bundle ?? rootBundle;
    final departmentSource = await assetBundle.loadString(
      'assets/data/departments.json',
    );
    final noticeSource = await assetBundle.loadString(
      'assets/data/notices.json',
    );
    final eventSource = await assetBundle.loadString(
      'assets/data/schedule.json',
    );

    final departments = _parseDepartments(departmentSource);
    final notices = _parseNotices(noticeSource);
    final events = _parseEvents(eventSource);
    _validateLoadedData(departments, notices, events);

    return CampusRepository._(
      departments: departments,
      notices: notices,
      events: events,
    );
  }

  /// 테스트나 미리보기용 목록으로 저장소를 만든다.
  factory CampusRepository.fromLists({
    required List<Department> departments,
    required List<Notice> notices,
    required List<ScheduleEvent> events,
  }) {
    return CampusRepository._(
      departments: departments,
      notices: notices,
      events: events,
    );
  }

  /// [id]에 해당하는 학과를 돌려주며 없으면 `null`을 돌려준다.
  Department? departmentById(String id) {
    for (final department in departments) {
      if (department.id == id) {
        return department;
      }
    }
    return null;
  }

  /// [id]에 해당하는 공지를 돌려주며 없으면 `null`을 돌려준다.
  Notice? noticeById(String id) {
    for (final notice in notices) {
      if (notice.id == id) {
        return notice;
      }
    }
    return null;
  }

  static List<Department> _parseDepartments(String source) {
    final objects = decodeObjectList(source, 'departments.json');
    return [
      for (final (index, object) in objects.indexed)
        Department.fromJson(object, 'departments.json[$index]'),
    ];
  }

  static List<Notice> _parseNotices(String source) {
    final objects = decodeObjectList(source, 'notices.json');
    return [
      for (final (index, object) in objects.indexed)
        Notice.fromJson(object, 'notices.json[$index]'),
    ];
  }

  static List<ScheduleEvent> _parseEvents(String source) {
    final objects = decodeObjectList(source, 'schedule.json');
    return [
      for (final (index, object) in objects.indexed)
        ScheduleEvent.fromJson(object, 'schedule.json[$index]'),
    ];
  }

  static void _validateLoadedData(
    List<Department> departments,
    List<Notice> notices,
    List<ScheduleEvent> events,
  ) {
    _ensureUniqueIds(departments.map((item) => item.id), 'departments.json');
    _ensureUniqueIds(notices.map((item) => item.id), 'notices.json');
    _ensureUniqueIds(events.map((item) => item.id), 'schedule.json');

    const expectedDepartmentIds = [
      'dept_ee',
      'dept_me',
      'dept_che',
      'dept_naval',
      'dept_cs',
      'dept_nursing',
      'dept_dental',
      'dept_child',
      'dept_tax',
      'dept_food',
      'dept_hotel',
      'dept_interior',
    ];
    final departmentIds = departments.map((item) => item.id).toList();
    if (!_sameItems(departmentIds, expectedDepartmentIds)) {
      throw const FormatException(
        'departments.json: 학과 id 12개와 순서가 데이터 규칙과 다르다.',
      );
    }

    for (final (index, event) in events.indexed) {
      if (event.endDate.isBefore(event.startDate)) {
        throw FormatException(
          'schedule.json[$index].endDate: startDate보다 이를 수 없다.',
        );
      }
    }
  }

  static void _ensureUniqueIds(Iterable<String> ids, String where) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) {
        throw FormatException('$where: id "$id"가 중복되었다.');
      }
    }
  }

  static bool _sameItems(List<String> left, List<String> right) {
    if (left.length != right.length) {
      return false;
    }
    for (var index = 0; index < left.length; index++) {
      if (left[index] != right[index]) {
        return false;
      }
    }
    return true;
  }
}

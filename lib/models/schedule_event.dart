import 'package:uc_campus/core/date_format.dart';
import 'package:uc_campus/models/json_parse.dart';

/// 일정의 임시 카테고리다.
enum ScheduleCategory {
  academic('학사'),
  admission('입학'),
  vacation('방학·휴일'),
  event('행사');

  const ScheduleCategory(this.label);

  final String label;
}

/// 로컬 JSON에서 읽는 학사 일정 정보다.
class ScheduleEvent {
  const ScheduleEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.note,
    required this.isSample,
  });

  /// JSON 객체를 일정으로 변환한다.
  /// 필드가 없거나 형식이 다르면 [FormatException]을 던진다.
  factory ScheduleEvent.fromJson(Map<String, dynamic> json, String where) {
    return ScheduleEvent(
      id: readString(json, 'id', where),
      title: readString(json, 'title', where),
      category: readEnum(ScheduleCategory.values, json, 'category', where),
      startDate: readDate(json, 'startDate', where),
      endDate: readDate(json, 'endDate', where),
      note: readOptionalString(json, 'note', where),
      isSample: readBool(json, 'isSample', where),
    );
  }

  final String id;
  final String title;
  final ScheduleCategory category;
  final DateTime startDate;
  final DateTime endDate;
  final String? note;
  final bool isSample;

  bool get isSingleDay => dateOnly(startDate) == dateOnly(endDate);

  /// 이 일정이 [from]부터 [to]까지의 기간과 하루라도 겹치는지 확인한다.
  bool overlaps(DateTime from, DateTime to) {
    return !(endDate.isBefore(dateOnly(from)) ||
        startDate.isAfter(dateOnly(to)));
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/models/schedule_event.dart';

void main() {
  group('Department.fromJson', () {
    Map<String, dynamic> validJson() => {
      'id': 'dept_cs',
      'name': '컴퓨터공학과',
      'track': 'engineering',
      'summary': '학습용 샘플 소개',
      'curriculum': ['프로그래밍'],
      'careers': ['개발'],
      'phone': null,
      'isSample': true,
    };

    test('정상 객체를 만든다', () {
      final department = Department.fromJson(validJson(), 'department');
      expect(department.track, DepartmentTrack.engineering);
      expect(department.phone, isNull);
    });

    test('필수 필드가 없으면 FormatException을 던진다', () {
      final json = validJson()..remove('name');
      expect(
        () => Department.fromJson(json, 'department'),
        throwsFormatException,
      );
    });

    test('알 수 없는 enum이면 FormatException을 던진다', () {
      final json = validJson()..['track'] = 'unknown';
      expect(
        () => Department.fromJson(json, 'department'),
        throwsFormatException,
      );
    });
  });

  group('Notice.fromJson', () {
    Map<String, dynamic> validJson() => {
      'id': 'notice_001',
      'title': '안내',
      'category': 'general',
      'body': '학습용 샘플 공지이다.',
      'postedAt': '2026-10-12',
      'sourceUrl': null,
      'isSample': true,
    };

    test('정상 객체를 만든다', () {
      final notice = Notice.fromJson(validJson(), 'notice');
      expect(notice.category, NoticeCategory.general);
      expect(notice.postedAt, DateTime(2026, 10, 12));
    });

    test('필수 필드가 없으면 FormatException을 던진다', () {
      final json = validJson()..remove('body');
      expect(() => Notice.fromJson(json, 'notice'), throwsFormatException);
    });

    test('알 수 없는 enum이면 FormatException을 던진다', () {
      final json = validJson()..['category'] = 'unknown';
      expect(() => Notice.fromJson(json, 'notice'), throwsFormatException);
    });
  });

  group('ScheduleEvent.fromJson', () {
    Map<String, dynamic> validJson() => {
      'id': 'event_001',
      'title': '일정',
      'category': 'academic',
      'startDate': '2026-10-12',
      'endDate': '2026-10-13',
      'note': null,
      'isSample': true,
    };

    test('정상 객체를 만들고 날짜 겹침을 계산한다', () {
      final event = ScheduleEvent.fromJson(validJson(), 'event');
      expect(event.category, ScheduleCategory.academic);
      expect(event.isSingleDay, isFalse);
      expect(
        event.overlaps(DateTime(2026, 10, 13), DateTime(2026, 10, 20)),
        isTrue,
      );
    });

    test('필수 필드가 없으면 FormatException을 던진다', () {
      final json = validJson()..remove('startDate');
      expect(
        () => ScheduleEvent.fromJson(json, 'event'),
        throwsFormatException,
      );
    });

    test('알 수 없는 enum이면 FormatException을 던진다', () {
      final json = validJson()..['category'] = 'unknown';
      expect(
        () => ScheduleEvent.fromJson(json, 'event'),
        throwsFormatException,
      );
    });
  });
}

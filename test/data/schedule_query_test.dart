import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/models/schedule_event.dart';

void main() {
  final event = ScheduleEvent(
    id: 'f',
    title: '접수',
    category: ScheduleCategory.admission,
    startDate: DateTime(2026, 11, 11),
    endDate: DateTime(2026, 11, 25),
    note: null,
    isSample: false,
  );
  final span = ScheduleEvent(
    id: 's',
    title: '샘플',
    category: ScheduleCategory.vacation,
    startDate: DateTime(2026, 9, 28),
    endDate: DateTime(2026, 10, 2),
    note: null,
    isSample: true,
  );
  final repository = CampusRepository.fromLists(
    departments: [],
    notices: [],
    events: [event, span],
  );
  test('여러 달 일정과 카테고리 및 빈 달을 확인한다', () {
    expect(repository.eventsInMonth(DateTime(2026, 9)), [span]);
    expect(repository.eventsInMonth(DateTime(2026, 10)), [span]);
    expect(
      repository.eventsInMonth(
        DateTime(2026, 10),
        category: ScheduleCategory.admission,
      ),
      isEmpty,
    );
    expect(repository.eventsInMonth(DateTime(2027)), isEmpty);
  });
  test('시작일·기간 중·종료일을 포함하고 종료 다음날 제외한다', () {
    for (final day in [11, 20, 25]) {
      final today = DateTime(2026, 11, day, 23);
      expect(repository.featuredEvent(today), event);
      expect(repository.upcomingEvents(today), [event]);
    }
    expect(repository.featuredEvent(DateTime(2026, 11, 26)), isNull);
    expect(repository.upcomingEvents(DateTime(2026, 11, 26)), isEmpty);
    expect(repository.upcomingEvents(DateTime(2026, 9)).first, span);
    expect(repository.upcomingEvents(DateTime(2026, 9), limit: 0), isEmpty);
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/core/date_format.dart';

void main() {
  test('dateOnly는 시간 정보를 제거한다', () {
    expect(dateOnly(DateTime(2026, 10, 12, 23, 59)), DateTime(2026, 10, 12));
  });

  test('addMonths는 연도가 바뀌는 앞뒤 이동을 처리한다', () {
    expect(addMonths(DateTime(2026, 12, 20), 1), DateTime(2027));
    expect(addMonths(DateTime(2026), -1), DateTime(2025, 12));
  });

  test('날짜 표시 함수가 한국어 형식으로 표시한다', () {
    expect(formatYearMonth(DateTime(2026, 11, 11)), '2026년 11월');
    expect(formatDate(DateTime(2026, 1, 2)), '2026-01-02');
    expect(formatMonthDay(DateTime(2026, 11, 11)), '11.11(수)');
  });

  test('formatRange는 같은 날, 같은 해, 다른 해를 구분한다', () {
    expect(
      formatRange(DateTime(2026, 11, 11), DateTime(2026, 11, 11)),
      '11.11(수)',
    );
    expect(
      formatRange(DateTime(2026, 11, 11), DateTime(2026, 11, 25)),
      '11.11(수) ~ 11.25(수)',
    );
    expect(
      formatRange(DateTime(2026, 12, 31), DateTime(2027)),
      '2026-12-31 ~ 2027-01-01',
    );
  });

  test('dDayLabel은 시작 전부터 종료 후까지 구분한다', () {
    final start = DateTime(2026, 11, 11);
    final end = DateTime(2026, 11, 25);

    expect(dDayLabel(start, end, DateTime(2026, 11)), 'D-10');
    expect(dDayLabel(start, end, start), 'D-day');
    expect(dDayLabel(start, end, DateTime(2026, 11, 20)), '진행 중');
    expect(dDayLabel(start, end, end), '진행 중');
    expect(dDayLabel(start, end, DateTime(2026, 11, 26)), '종료');
  });
}

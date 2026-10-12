/// 시간 정보를 버리고 연, 월, 일만 남긴다.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// [month]에서 [delta]개월 이동한 달의 1일을 돌려준다.
DateTime addMonths(DateTime month, int delta) {
  return DateTime(month.year, month.month + delta);
}

/// 날짜를 `yyyy년 M월` 형식으로 표시한다.
String formatYearMonth(DateTime date) => '${date.year}년 ${date.month}월';

/// 날짜를 `yyyy-MM-dd` 형식으로 표시한다.
String formatDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// 날짜를 `MM.dd(요일)` 형식으로 표시한다.
String formatMonthDay(DateTime date) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$month.$day(${weekdays[date.weekday - 1]})';
}

/// 시작일과 종료일을 같은 날, 같은 해, 다른 해에 맞게 표시한다.
String formatRange(DateTime start, DateTime end) {
  final startDate = dateOnly(start);
  final endDate = dateOnly(end);
  if (startDate == endDate) {
    return formatMonthDay(startDate);
  }
  if (startDate.year == endDate.year) {
    return '${formatMonthDay(startDate)} ~ ${formatMonthDay(endDate)}';
  }
  return '${formatDate(startDate)} ~ ${formatDate(endDate)}';
}

/// [today]가 기간의 어느 위치인지 D-day 문구로 표시한다.
String dDayLabel(DateTime start, DateTime end, DateTime today) {
  final startDate = dateOnly(start);
  final endDate = dateOnly(end);
  final todayDate = dateOnly(today);

  if (todayDate.isBefore(startDate)) {
    final utcStart = DateTime.utc(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final utcToday = DateTime.utc(
      todayDate.year,
      todayDate.month,
      todayDate.day,
    );
    return 'D-${utcStart.difference(utcToday).inDays}';
  }
  if (todayDate == startDate) {
    return 'D-day';
  }
  if (!todayDate.isAfter(endDate)) {
    return '진행 중';
  }
  return '종료';
}

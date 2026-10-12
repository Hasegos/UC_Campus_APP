import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CampusRepository repository;

  setUpAll(() async {
    repository = await CampusRepository.load();
  });

  test('JSON 수량과 id 유일성을 확인한다', () {
    expect(repository.departments, hasLength(12));
    expect(repository.notices.length, greaterThanOrEqualTo(24));
    expect(repository.events.length, greaterThanOrEqualTo(16));

    expect(
      repository.departments.map((item) => item.id).toSet(),
      hasLength(repository.departments.length),
    );
    expect(
      repository.notices.map((item) => item.id).toSet(),
      hasLength(repository.notices.length),
    );
    expect(
      repository.events.map((item) => item.id).toSet(),
      hasLength(repository.events.length),
    );
  });

  test('모든 일정의 종료일은 시작일보다 빠르지 않다', () {
    for (final event in repository.events) {
      expect(
        event.endDate.isBefore(event.startDate),
        isFalse,
        reason: event.id,
      );
    }
  });

  test('id 조회는 항목 또는 null을 돌려준다', () {
    expect(repository.departmentById('dept_cs')?.name, '컴퓨터공학과');
    expect(repository.noticeById('notice_024')?.isSample, isFalse);
    expect(repository.departmentById('missing'), isNull);
    expect(repository.noticeById('missing'), isNull);
  });
}

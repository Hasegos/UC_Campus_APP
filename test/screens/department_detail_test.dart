import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/screens/departments/department_detail_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CampusRepository repository;
  setUpAll(() async => repository = await CampusRepository.load());

  testWidgets('모든 학과가 라이트·다크 및 글자 1.5배에서 렌더링된다', (tester) async {
    for (final brightness in Brightness.values) {
      for (final department in repository.departments) {
        await pumpScreen(
          tester,
          screen: DepartmentDetailScreen(department: department),
          repository: repository,
          state: AppState(),
          brightness: brightness,
          textScale: 1.5,
        );
        expect(find.text(department.name), findsOneWidget);
        expect(find.text('샘플'), findsOneWidget);
        await tester.scrollUntilVisible(find.text('연락처'), 150);
        expect(find.text('정보 없음'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });
  testWidgets('상단 하트와 하단 버튼이 찜 상태를 공유한다', (tester) async {
    final state = AppState();
    final department = repository.departments.first;
    await pumpScreen(
      tester,
      screen: DepartmentDetailScreen(department: department),
      repository: repository,
      state: state,
    );
    await tester.tap(find.byTooltip('찜하기'));
    await tester.pump();
    expect(state.isFavorite(department.id), isTrue);
    expect(find.byTooltip('찜 해제'), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(FilledButton), 150);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(state.isFavorite(department.id), isFalse);
    expect(find.byTooltip('찜하기'), findsOneWidget);
  });
  testWidgets('빈 교육과정과 진로는 정보 없음을 표시한다', (tester) async {
    const department = Department(
      id: 'empty',
      name: '빈 학과',
      track: DepartmentTrack.health,
      summary: '학습용 샘플',
      curriculum: [],
      careers: [],
      phone: null,
      isSample: true,
    );
    await pumpScreen(
      tester,
      screen: const DepartmentDetailScreen(department: department),
      repository: repository,
      state: AppState(),
    );
    expect(find.text('정보 없음'), findsNWidgets(3));
  });
}

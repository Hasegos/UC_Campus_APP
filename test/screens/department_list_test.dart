import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/data/sort_options.dart';
import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/screens/app_shell.dart';
import 'package:uc_campus/screens/departments/department_detail_screen.dart';
import 'package:uc_campus/screens/departments/department_list_screen.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/department_tile.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CampusRepository repository;
  setUpAll(() async => repository = await CampusRepository.load());

  testWidgets('검색·지우기·빈 결과 초기화가 개수를 변경한다', (tester) async {
    await pumpScreen(
      tester,
      screen: const DepartmentListScreen(),
      repository: repository,
      state: AppState(),
    );
    expect(find.text('12개 학과'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '컴퓨터');
    await tester.pump();
    expect(find.text('1개 학과'), findsOneWidget);
    expect(find.text('컴퓨터공학과'), findsOneWidget);
    await tester.tap(find.byTooltip('검색어 지우기'));
    await tester.pump();
    expect(find.text('12개 학과'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump();
    expect(find.text('조건에 맞는 학과가 없어요.'), findsOneWidget);
    await tester.tap(find.text('필터 초기화'));
    await tester.pump();
    expect(find.text('12개 학과'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      '',
    );
  });

  testWidgets('계열별 개수와 정렬·찜 우선 동작을 확인한다', (tester) async {
    final state = AppState();
    await pumpScreen(
      tester,
      screen: const DepartmentListScreen(),
      repository: repository,
      state: state,
    );
    for (final (track, count) in [
      (DepartmentTrack.engineering, 5),
      (DepartmentTrack.health, 2),
      (DepartmentTrack.eduBusiness, 2),
      (DepartmentTrack.lifeDesign, 3),
    ]) {
      final chip = find.widgetWithText(FilterChip, track.label);
      await tester.ensureVisible(chip);
      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(find.text('$count개 학과'), findsOneWidget);
    }
    final all = find.widgetWithText(FilterChip, '전체');
    await tester.ensureVisible(all);
    await tester.tap(all);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('정렬'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<DepartmentSort>, '이름순'),
    );
    await tester.pumpAndSettle();
    final sortedNames = repository.departments.map((item) => item.name).toList()
      ..sort();
    expect(
      tester
          .widget<DepartmentTile>(find.byType(DepartmentTile).first)
          .department
          .name,
      sortedNames.first,
    );
    state.toggleFavorite('dept_cs');
    await tester.tap(find.byTooltip('정렬'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<DepartmentSort>, '찜 우선'),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DepartmentTile>(find.byType(DepartmentTile).first)
          .department
          .id,
      'dept_cs',
    );
    await tester.tap(find.byTooltip('찜 해제').first);
    await tester.pumpAndSettle();
    expect(state.isFavorite('dept_cs'), isFalse);
    expect(
      tester
          .widget<DepartmentTile>(find.byType(DepartmentTile).first)
          .department
          .id,
      'dept_ee',
    );
  });

  testWidgets('목록에서 상세로 이동하고 찜 변경이 목록에 반영된다', (tester) async {
    final state = AppState();
    await pumpScreen(
      tester,
      screen: const AppShell(),
      repository: repository,
      state: state,
    );
    await tester.tap(find.widgetWithText(NavigationDestination, '학과'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '컴퓨터');
    await tester.pump();
    await tester.tap(find.text('컴퓨터공학과'));
    await tester.pumpAndSettle();
    expect(find.byType(DepartmentDetailScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.byTooltip('찜하기'));
    await tester.pump();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('찜 해제'), findsOneWidget);
    await tester.tap(find.widgetWithText(NavigationDestination, '공지'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(NavigationDestination, '학과'));
    await tester.pumpAndSettle();
    expect(find.text('1개 학과'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      '컴퓨터',
    );
    await tester.tap(find.byTooltip('검색어 지우기'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilterChip, '보건'));
    await tester.pump();
    await tester.tap(find.widgetWithText(NavigationDestination, '공지'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(NavigationDestination, '학과'));
    await tester.pumpAndSettle();
    expect(find.text('2개 학과'), findsOneWidget);
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, '보건')).selected,
      isTrue,
    );
  });

  testWidgets('목록이 라이트·다크 및 글자 1.5배에서 읽힌다', (tester) async {
    for (final brightness in Brightness.values) {
      await pumpScreen(
        tester,
        screen: const DepartmentListScreen(),
        repository: repository,
        state: AppState(),
        brightness: brightness,
        textScale: 1.5,
      );
      expect(find.text('12개 학과'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}

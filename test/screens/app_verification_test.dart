import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/app.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/screens/departments/department_detail_screen.dart';
import 'package:uc_campus/screens/departments/department_list_screen.dart';
import 'package:uc_campus/screens/home/home_screen.dart';
import 'package:uc_campus/screens/my/my_screen.dart';
import 'package:uc_campus/screens/notices/notice_detail_screen.dart';
import 'package:uc_campus/screens/notices/notice_list_screen.dart';
import 'package:uc_campus/screens/schedule/schedule_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CampusRepository repository;
  setUpAll(() async => repository = await CampusRepository.load());

  testWidgets('7개 화면의 모바일 폭·라이트·다크·글자 1.5배 전체 스크롤', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final brightness in Brightness.values) {
      final state = AppState()
        ..toggleFavorite('dept_cs')
        ..toggleBookmark('notice_001')
        ..setMemo('notice_001', '발표 메모');
      final screens = [
        HomeScreen(onSelectTab: (_) {}, now: DateTime(2026, 10, 13)),
        const DepartmentListScreen(),
        DepartmentDetailScreen(department: repository.departments[3]),
        const NoticeListScreen(),
        NoticeDetailScreen(notice: repository.notices[2]),
        ScheduleScreen(now: DateTime(2026, 11)),
        MyScreen(onSelectTab: (_) {}),
      ];
      for (final screen in screens) {
        await tester.pumpWidget(const SizedBox.shrink());
        await pumpScreen(
          tester,
          screen: screen,
          repository: repository,
          state: state,
          brightness: brightness,
          textScale: 1.5,
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${screen.runtimeType} $brightness',
        );
        final vertical = find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              (widget.axisDirection == AxisDirection.down ||
                  widget.axisDirection == AxisDirection.up),
        );
        if (vertical.evaluate().isNotEmpty) {
          for (var count = 0; count < 8; count++) {
            await tester.drag(vertical.first, const Offset(0, -350));
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: '${screen.runtimeType} scrolling $brightness',
            );
          }
        }
      }
    }
  });

  testWidgets('앱 테마가 실제 반영되고 로그인 인사말·찜·메모가 탭 사이에 연결된다', (tester) async {
    final state = AppState();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<CampusRepository>.value(value: repository),
          ChangeNotifierProvider<AppState>.value(value: state),
        ],
        child: const UcCampusApp(),
      ),
    );
    state.login('학생');
    state.setThemeMode(ThemeMode.dark);
    state.toggleFavorite('dept_cs');
    state.toggleBookmark('notice_001');
    state.setMemo('notice_001', '발표 메모');
    await tester.pumpAndSettle();
    expect(find.text('안녕하세요, 학생님'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    await tester.tap(find.widgetWithText(NavigationDestination, '마이'));
    await tester.pumpAndSettle();
    final list = find
        .descendant(
          of: find.byType(MyScreen),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(find.text('발표 메모'), 300, scrollable: list);
    expect(find.text('찜한 학과 (1)'), findsOneWidget);
    expect(find.text('북마크한 공지 (1)'), findsOneWidget);
    expect(find.text('내 메모 (1)'), findsOneWidget);
    state.logout();
    await tester.pump();
    await tester.tap(find.widgetWithText(NavigationDestination, '홈'));
    await tester.pumpAndSettle();
    expect(find.text('UCheck 캠퍼스에 오신 걸 환영해요'), findsOneWidget);
  });
}

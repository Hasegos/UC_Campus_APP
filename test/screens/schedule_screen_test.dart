import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/screens/schedule/schedule_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('접수 일정·달 이동·빈 달·오늘 복귀·필터 유지', (tester) async {
    final repository = await CampusRepository.load();
    await pumpScreen(
      tester,
      screen: ScheduleScreen(now: DateTime(2026, 11, 13)),
      repository: repository,
      state: AppState(),
    );
    expect(find.text('2026학년도 수시 2차 접수'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilterChip, '입학'));
    await tester.pump();
    await tester.tap(find.byTooltip('다음 달'));
    await tester.pump();
    expect(find.text('2026년 12월'), findsOneWidget);
    await tester.tap(find.byTooltip('다음 달'));
    await tester.pump();
    expect(find.text('2027년 1월'), findsOneWidget);
    expect(find.text('이 달에는 일정이 없어요.'), findsOneWidget);
    expect(
      tester.widget<FilterChip>(find.widgetWithText(FilterChip, '입학')).selected,
      isTrue,
    );
    await tester.tap(find.text('오늘'));
    await tester.pump();
    expect(find.text('2026년 11월'), findsOneWidget);
  });
}

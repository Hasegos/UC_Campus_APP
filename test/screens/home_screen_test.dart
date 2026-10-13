import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/screens/home/home_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('인사말·빠른 탭·D-day와 종료 후 숨김', (tester) async {
    final repository = await CampusRepository.load();
    final state = AppState();
    var selected = 0;
    await pumpScreen(
      tester,
      screen: HomeScreen(
        now: DateTime(2026, 10, 12),
        onSelectTab: (tab) => selected = tab,
      ),
      repository: repository,
      state: state,
    );
    expect(find.text('D-30'), findsOneWidget);
    expect(find.text('2026-11-11 ~ 2026-11-25'), findsOneWidget);
    state.login('학생');
    await tester.pump();
    expect(find.text('안녕하세요, 학생님'), findsOneWidget);
    for (final (label, index) in [('학과', 1), ('공지', 2), ('일정', 3), ('마이', 4)]) {
      await tester.tap(find.widgetWithText(FilledButton, label));
      expect(selected, index);
    }
    await pumpScreen(
      tester,
      screen: HomeScreen(now: DateTime(2026, 11, 26), onSelectTab: (_) {}),
      repository: repository,
      state: state,
    );
    expect(find.text('2026-11-11 ~ 2026-11-25'), findsNothing);
  });
}

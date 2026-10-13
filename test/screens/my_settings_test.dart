import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/screens/my/my_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  testWidgets('로그인 검증·로그아웃·테마·샘플 안내', (tester) async {
    final state = AppState();
    final repository = CampusRepository.fromLists(
      departments: [],
      notices: [],
      events: [],
    );
    await pumpScreen(
      tester,
      screen: MyScreen(onSelectTab: (_) {}),
      repository: repository,
      state: state,
    );
    await tester.tap(find.text('로그인'));
    await tester.pump();
    expect(find.text('입력해 주세요'), findsNWidgets(2));
    await tester.enterText(find.byType(TextFormField).first, '학생');
    await tester.enterText(find.byType(TextFormField).last, '임의값');
    await tester.tap(find.text('로그인'));
    await tester.pump();
    expect(find.text('학생님'), findsOneWidget);
    expect(find.textContaining('학습용 샘플 데이터예요.'), findsOneWidget);
    await tester.ensureVisible(find.text('다크'));
    await tester.tap(find.text('다크'));
    await tester.pump();
    expect(state.themeMode, ThemeMode.dark);
    await tester.scrollUntilVisible(
      find.text('로그아웃'),
      -300,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.text('로그아웃'));
    await tester.pump();
    expect(state.userName, isNull);
    expect(state.themeMode, ThemeMode.dark);
  });
}

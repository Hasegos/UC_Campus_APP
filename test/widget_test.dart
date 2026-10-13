import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/app.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/state/app_state.dart';

void main() {
  testWidgets('하단 탭 전환과 학과 화면 연결 및 홈 복귀를 확인한다', (tester) async {
    final repository = CampusRepository.fromLists(
      departments: const [],
      notices: const [],
      events: const [],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<CampusRepository>.value(value: repository),
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const UcCampusApp(),
      ),
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('홈 화면은 준비 중이에요.'), findsOneWidget);

    for (final label in ['학과', '공지', '일정', '마이']) {
      await tester.tap(find.text(label));
      await tester.pump();
      if (label == '학과') {
        expect(find.text('0개 학과'), findsOneWidget);
      } else {
        expect(find.text('$label 화면은 준비 중이에요.'), findsOneWidget);
      }
    }

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('홈 화면은 준비 중이에요.'), findsOneWidget);
  });
}

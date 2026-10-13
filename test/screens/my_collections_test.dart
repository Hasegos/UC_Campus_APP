import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/screens/my/my_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('찜·북마크·메모가 표시되고 해제 시 빈 상태로 전환된다', (tester) async {
    final repository = await CampusRepository.load();
    final state = AppState()
      ..toggleFavorite('dept_cs')
      ..toggleBookmark('notice_001')
      ..setMemo('notice_001', '확인할 내용');
    var selected = 0;
    await pumpScreen(
      tester,
      screen: MyScreen(onSelectTab: (tab) => selected = tab),
      repository: repository,
      state: state,
    );
    final scrollable = find
        .descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('컴퓨터공학과'),
      300,
      scrollable: scrollable,
    );
    await tester.tap(find.byTooltip('찜 해제'));
    await tester.pump();
    expect(state.isFavorite('dept_cs'), isFalse);
    await tester.ensureVisible(find.text('학과 보러 가기'));
    await tester.tap(find.text('학과 보러 가기'));
    expect(selected, 1);
    await tester.scrollUntilVisible(
      find.byTooltip('북마크 해제'),
      300,
      scrollable: scrollable,
    );
    await tester.tap(find.byTooltip('북마크 해제'));
    await tester.pump();
    expect(state.isBookmarked('notice_001'), isFalse);
    await tester.scrollUntilVisible(
      find.text('확인할 내용'),
      300,
      scrollable: scrollable,
    );
    expect(find.text('내 메모 (1)'), findsOneWidget);
    state.setMemo('notice_001', '');
    await tester.pump();
    expect(find.text('작성한 메모가 없어요.'), findsOneWidget);
  });
}

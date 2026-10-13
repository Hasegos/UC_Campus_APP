import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/screens/notices/notice_detail_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  final notice = Notice(
    id: 'n',
    title: '메모 테스트',
    category: NoticeCategory.general,
    body: '학습용 샘플',
    postedAt: DateTime(2026, 10, 13),
    sourceUrl: null,
    isSample: true,
  );
  final repository = CampusRepository.fromLists(
    departments: [],
    notices: [notice],
    events: [],
  );
  testWidgets('메모 저장·재진입·공백 삭제·명시적 삭제 및 북마크', (tester) async {
    final state = AppState();
    await pumpScreen(
      tester,
      screen: NoticeDetailScreen(notice: notice),
      repository: repository,
      state: state,
    );
    await tester.enterText(find.byType(TextField), '  내 메모  ');
    await tester.tap(find.text('저장'));
    await tester.pump();
    expect(state.memoFor('n'), '내 메모');
    expect(find.text('저장했어요'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await pumpScreen(
      tester,
      screen: NoticeDetailScreen(notice: notice),
      repository: repository,
      state: state,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      '내 메모',
    );
    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('저장'));
    await tester.pump();
    expect(state.memoFor('n'), isNull);
    await tester.enterText(find.byType(TextField), '다시 저장');
    await tester.tap(find.text('저장'));
    await tester.pump();
    await tester.tap(find.text('삭제'));
    await tester.pump();
    expect(state.memoFor('n'), isNull);
    await tester.tap(find.byTooltip('북마크'));
    await tester.pump();
    expect(state.isBookmarked('n'), isTrue);
  });
}

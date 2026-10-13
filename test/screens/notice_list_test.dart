import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/screens/notices/notice_list_screen.dart';
import 'package:uc_campus/state/app_state.dart';
import 'package:uc_campus/widgets/notice_tile.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CampusRepository repository;
  setUpAll(() async => repository = await CampusRepository.load());
  testWidgets('검색·빈 결과 초기화·읽음·북마크·메모 재진입', (tester) async {
    final state = AppState();
    await pumpScreen(
      tester,
      screen: const NoticeListScreen(),
      repository: repository,
      state: state,
    );
    expect(find.text('24개 공지'), findsOneWidget);
    expect(
      tester.widget<NoticeTile>(find.byType(NoticeTile).first).isRead,
      isFalse,
    );
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump();
    expect(find.text('조건에 맞는 공지가 없어요.'), findsOneWidget);
    await tester.tap(find.text('필터 초기화'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), '2학기 수강신청');
    await tester.pump();
    expect(find.text('1개 공지'), findsOneWidget);
    await tester.tap(find.byType(NoticeTile));
    await tester.pumpAndSettle();
    expect(state.isRead('notice_001'), isTrue);
    await tester.tap(find.byTooltip('북마크'));
    await tester.pump();
    await tester.scrollUntilVisible(find.byType(TextField), 200);
    await tester.enterText(find.byType(TextField), '읽고 확인');
    await tester.ensureVisible(find.text('저장'));
    await tester.tap(find.text('저장'));
    await tester.pump();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(tester.widget<NoticeTile>(find.byType(NoticeTile)).isRead, isTrue);
    expect(find.byTooltip('북마크 해제'), findsOneWidget);
    await tester.tap(find.byType(NoticeTile));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(TextField), 200);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      '읽고 확인',
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/screens/notices/notice_detail_screen.dart';
import 'package:uc_campus/state/app_state.dart';

import '../helpers/pump_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('긴 본문 메모를 키보드가 올라온 휴대폰 화면에서 저장한다', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    final repository = await CampusRepository.load();
    final state = AppState();
    await pumpScreen(
      tester,
      screen: NoticeDetailScreen(notice: repository.notices[2]),
      repository: repository,
      state: state,
      textScale: 1.5,
    );
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), '긴 공지를 읽고 저장');
    await tester.ensureVisible(find.text('저장'));
    await tester.tap(find.text('저장'));
    await tester.pump();
    expect(state.memoFor(repository.notices[2].id), '긴 공지를 읽고 저장');
    expect(tester.takeException(), isNull);
  });
}

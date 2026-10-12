import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uc_campus/state/app_state.dart';

void main() {
  test('찜, 북마크, 읽음 상태를 변경하고 같은 읽음은 알리지 않는다', () {
    final state = AppState();
    var notifications = 0;
    state.addListener(() => notifications++);

    state.toggleFavorite('dept_cs');
    expect(state.isFavorite('dept_cs'), isTrue);
    state.toggleFavorite('dept_cs');
    expect(state.isFavorite('dept_cs'), isFalse);

    state.toggleBookmark('notice_001');
    expect(state.isBookmarked('notice_001'), isTrue);
    state.toggleBookmark('notice_001');
    expect(state.isBookmarked('notice_001'), isFalse);

    state.markRead('notice_001');
    state.markRead('notice_001');
    expect(state.isRead('notice_001'), isTrue);
    expect(notifications, 5);
  });

  test('메모는 trim 후 저장하고 공백이면 삭제한다', () {
    final state = AppState();
    var notifications = 0;
    state.addListener(() => notifications++);

    state.setMemo('notice_001', '  내 메모  ');
    expect(state.memoFor('notice_001'), '내 메모');
    state.setMemo('notice_001', '내 메모');
    expect(notifications, 1);

    state.setMemo('notice_001', '   ');
    expect(state.memoFor('notice_001'), isNull);
    state.setMemo('notice_001', '');
    expect(notifications, 2);
  });

  test('로그인과 로그아웃은 이름만 바뀔 때 알린다', () {
    final state = AppState();
    var notifications = 0;
    state.addListener(() => notifications++);

    state.login('   ');
    expect(state.isLoggedIn, isFalse);
    state.login('  학생  ');
    expect(state.userName, '학생');
    state.login('학생');
    expect(notifications, 1);

    state.toggleFavorite('dept_cs');
    state.logout();
    state.logout();
    expect(state.isLoggedIn, isFalse);
    expect(state.isFavorite('dept_cs'), isTrue);
    expect(notifications, 3);
  });

  test('테마는 실제 값이 바뀔 때만 알린다', () {
    final state = AppState();
    var notifications = 0;
    state.addListener(() => notifications++);

    expect(state.themeMode, ThemeMode.system);
    state.setThemeMode(ThemeMode.dark);
    state.setThemeMode(ThemeMode.dark);
    expect(state.themeMode, ThemeMode.dark);
    expect(notifications, 1);
  });
}

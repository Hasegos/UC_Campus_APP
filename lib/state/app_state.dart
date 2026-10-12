import 'package:flutter/material.dart';

/// 여러 화면이 함께 쓰는 사용자 선택 상태를 메모리에 보관한다.
class AppState extends ChangeNotifier {
  Set<String> _favoriteDeptIds = const {};
  Set<String> _bookmarkedNoticeIds = const {};
  Set<String> _readNoticeIds = const {};
  Map<String, String> _memos = const {};
  ThemeMode _themeMode = ThemeMode.system;
  String? _userName;

  Set<String> get favoriteDeptIds => _favoriteDeptIds;
  Set<String> get bookmarkedNoticeIds => _bookmarkedNoticeIds;
  Set<String> get readNoticeIds => _readNoticeIds;
  Map<String, String> get memos => _memos;
  ThemeMode get themeMode => _themeMode;
  String? get userName => _userName;
  bool get isLoggedIn => _userName != null;

  bool isFavorite(String id) => _favoriteDeptIds.contains(id);
  bool isBookmarked(String id) => _bookmarkedNoticeIds.contains(id);
  bool isRead(String id) => _readNoticeIds.contains(id);
  String? memoFor(String noticeId) => _memos[noticeId];

  /// 학과를 찜했으면 해제하고, 아니면 찜한다.
  void toggleFavorite(String id) {
    final updated = Set<String>.of(_favoriteDeptIds);
    updated.contains(id) ? updated.remove(id) : updated.add(id);
    _favoriteDeptIds = Set.unmodifiable(updated);
    notifyListeners();
  }

  /// 공지를 북마크했으면 해제하고, 아니면 북마크한다.
  void toggleBookmark(String id) {
    final updated = Set<String>.of(_bookmarkedNoticeIds);
    updated.contains(id) ? updated.remove(id) : updated.add(id);
    _bookmarkedNoticeIds = Set.unmodifiable(updated);
    notifyListeners();
  }

  /// 공지를 읽음으로 표시한다.
  /// 이미 읽은 공지이면 알리지 않는다.
  void markRead(String id) {
    if (_readNoticeIds.contains(id)) {
      return;
    }
    _readNoticeIds = Set.unmodifiable({..._readNoticeIds, id});
    notifyListeners();
  }

  /// 공백을 정리한 메모를 저장하고 빈 값이면 기존 메모를 지운다.
  void setMemo(String noticeId, String text) {
    final trimmed = text.trim();
    final current = _memos[noticeId];
    if (trimmed.isEmpty) {
      if (current == null) {
        return;
      }
      final updated = Map<String, String>.of(_memos)..remove(noticeId);
      _memos = Map.unmodifiable(updated);
      notifyListeners();
      return;
    }
    if (current == trimmed) {
      return;
    }
    _memos = Map.unmodifiable({..._memos, noticeId: trimmed});
    notifyListeners();
  }

  /// 앱 테마를 바꾸고 같은 값이면 알리지 않는다.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
  }

  /// 공백을 정리한 이름으로 로그인한다.
  /// 빈 이름이거나 현재 이름과 같으면 알리지 않는다.
  void login(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || _userName == trimmed) {
      return;
    }
    _userName = trimmed;
    notifyListeners();
  }

  /// 로그인 이름만 지우고 다른 사용자 선택은 유지한다.
  void logout() {
    if (_userName == null) {
      return;
    }
    _userName = null;
    notifyListeners();
  }
}

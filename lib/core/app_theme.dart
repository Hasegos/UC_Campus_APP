import 'package:flutter/material.dart';

/// 앱의 라이트 테마와 다크 테마를 만든다.
abstract final class AppTheme {
  static const Color _seedColor = Color(0xFF4F46E5);
  static const Color _lightBackground = Color(0xFFF6F7FB);
  static const Color _lightCard = Color(0xFFFFFFFF);

  /// Material 3 기반 라이트 테마를 돌려준다.
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _lightBackground,
      cardTheme: const CardThemeData(color: _lightCard),
    );
  }

  /// Material 3 기반 다크 테마를 돌려준다.
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardTheme: CardThemeData(color: colorScheme.surfaceContainer),
    );
  }
}

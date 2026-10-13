import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_theme.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/state/app_state.dart';

/// 화면 테스트에 저장소와 공유 상태 및 앱 테마를 주입한다.
Future<void> pumpScreen(
  WidgetTester tester, {
  required Widget screen,
  required CampusRepository repository,
  required AppState state,
  Brightness brightness = Brightness.light,
  double textScale = 1,
}) {
  return tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<CampusRepository>.value(value: repository),
        ChangeNotifierProvider<AppState>.value(value: state),
      ],
      child: MaterialApp(
        theme: brightness == Brightness.light
            ? AppTheme.light()
            : AppTheme.dark(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child ?? const SizedBox.shrink(),
        ),
        home: screen,
      ),
    ),
  );
}

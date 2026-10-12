import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/core/app_theme.dart';
import 'package:uc_campus/screens/app_shell.dart';
import 'package:uc_campus/state/app_state.dart';

/// UCheck 캠퍼스의 테마와 첫 화면을 구성한다.
class UcCampusApp extends StatelessWidget {
  const UcCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select((AppState state) => state.themeMode);

    return MaterialApp(
      title: 'UCheck 캠퍼스',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const AppShell(),
    );
  }
}

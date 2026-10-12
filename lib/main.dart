import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/app.dart';
import 'package:uc_campus/core/app_spacing.dart';
import 'package:uc_campus/data/campus_repository.dart';
import 'package:uc_campus/state/app_state.dart';

/// 로컬 JSON을 읽고 앱에서 사용할 저장소와 공유 상태를 주입한다.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final repository = await CampusRepository.load();
    runApp(
      MultiProvider(
        providers: [
          Provider<CampusRepository>.value(value: repository),
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const UcCampusApp(),
      ),
    );
  } on Object catch (error) {
    runApp(_StartupErrorApp(message: error.toString()));
  }
}

/// 앱 시작 데이터 오류를 화면에 표시한다.
class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text('앱 데이터를 불러오지 못했어요.\n$message'),
          ),
        ),
      ),
    );
  }
}

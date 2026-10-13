import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/models/notice.dart';
import 'package:uc_campus/screens/departments/department_detail_screen.dart';
import 'package:uc_campus/screens/notices/notice_detail_screen.dart';
import 'package:uc_campus/state/app_state.dart';

/// 상세 화면을 열기 직전에 공지를 읽음으로 표시한다.
void openNotice(BuildContext context, Notice notice) {
  context.read<AppState>().markRead(notice.id);
  Navigator.of(context).push<void>(
    MaterialPageRoute(builder: (_) => NoticeDetailScreen(notice: notice)),
  );
}

/// 학과 상세를 루트 화면 위에 열어 하단 탭 바를 덮는다.
void openDepartment(BuildContext context, Department department) {
  Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => DepartmentDetailScreen(department: department),
    ),
  );
}

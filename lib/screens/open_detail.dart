import 'package:flutter/material.dart';

import 'package:uc_campus/models/department.dart';
import 'package:uc_campus/screens/departments/department_detail_screen.dart';

/// 학과 상세를 루트 화면 위에 열어 하단 탭 바를 덮는다.
void openDepartment(BuildContext context, Department department) {
  Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (_) => DepartmentDetailScreen(department: department),
    ),
  );
}

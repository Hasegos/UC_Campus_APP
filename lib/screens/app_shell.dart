import 'package:flutter/material.dart';

import 'package:uc_campus/screens/departments/department_list_screen.dart';
import 'package:uc_campus/screens/notices/notice_list_screen.dart';

/// 하단 탭 다섯 개의 선택 상태와 자리표시 화면을 관리한다.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: '홈',
    ),
    NavigationDestination(
      icon: Icon(Icons.school_outlined),
      selectedIcon: Icon(Icons.school),
      label: '학과',
    ),
    NavigationDestination(
      icon: Icon(Icons.campaign_outlined),
      selectedIcon: Icon(Icons.campaign),
      label: '공지',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_month_outlined),
      selectedIcon: Icon(Icons.calendar_month),
      label: '일정',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: '마이',
    ),
  ];

  static const _pages = [
    _PendingPage(title: '홈'),
    DepartmentListScreen(),
    NoticeListScreen(),
    _PendingPage(title: '일정'),
    _PendingPage(title: '마이'),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _tab != 0) {
          setState(() => _tab = 0);
        }
      },
      child: Scaffold(
        body: IndexedStack(index: _tab, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          destinations: _destinations,
          onDestinationSelected: (index) => setState(() => _tab = index),
        ),
      ),
    );
  }
}

/// 아직 구현하지 않은 탭의 범위를 분명히 보여준다.
class _PendingPage extends StatelessWidget {
  const _PendingPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title 화면은 준비 중이에요.')),
    );
  }
}

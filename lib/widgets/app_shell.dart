import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_nav.dart';
import '/screens/user/insight.dart';
import '/screens/user/dashboard_screen.dart';
import '/screens/user/more_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    StatisticsScreen(),
    InsightsScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),

      // 👉 CHỈ BODY THAY ĐỔI
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

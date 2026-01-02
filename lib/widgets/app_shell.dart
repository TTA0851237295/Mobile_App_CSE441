import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_nav.dart';
import 'more_shell.dart';
import '../screens/user/insight.dart';
import '../screens/user/dashboard_screen.dart';
import '../screens/user/stress_relief_screen.dart';
import '../providers/checkin_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/theme_provider.dart';

// Global key để truy cập AppShell state từ bên ngoài
final GlobalKey<AppShellState> appShellKey = GlobalKey<AppShellState>();

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    StressReliefScreen(),
    StatisticsScreen(),
    InsightsScreen(),
    MoreShell(),
  ];

  // Phương thức để chuyển tab từ bên ngoài
  void switchToTab(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // Phương thức để chuyển đến tab Check-in (index 0)
  void goToCheckInTab() {
    switchToTab(0);
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckinProvider>().fetchCheckins();
      context.read<DashboardProvider>().fetchStats(days: 7); // Default 7 days
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121218) : null,
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


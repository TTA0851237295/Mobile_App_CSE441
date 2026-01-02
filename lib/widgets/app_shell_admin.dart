import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_bar_admin.dart';
import 'bottom_nav_admin.dart';
import '../screens/admin/admin_home.dart';
import '../screens/admin/admin_settings.dart';
import '../screens/admin/admin_setting_screen.dart';
import '../providers/theme_provider.dart';


// nếu chưa có, có thể để tạm Container()

class AppShellAdmin extends StatefulWidget {
  const AppShellAdmin({super.key});

  @override
  State<AppShellAdmin> createState() => _AppShellAdminState();
}

class _AppShellAdminState extends State<AppShellAdmin> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    /// ⭐⭐ TẠO DANH SÁCH PAGES NGAY TRONG BUILD() ⭐⭐
    final List<Widget> _pages = [
  AdminDashboardBody(),

  // Trang Settings tổng quan
  AdminSettingsBody(
    onOpenSettings: () {
      setState(() {
        _currentIndex = 2;
      });
    },
  ),

  // Trang Settings chi tiết
  AdminSettingsScreen(
    onBack: () {
      setState(() {
        _currentIndex = 1; // quay về tab Setting tổng quan
      });
    },
  ),
];
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121218) : const Color(0xFFF8F3FF),
      appBar: const AppBarAdmin(),

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

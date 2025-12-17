import 'package:flutter/material.dart';
import 'app_bar_admin.dart';
import 'bottom_nav_admin.dart';
import 'package:mobileapp_taman/screens/admin/admin_dashboard.dart';
import 'package:mobileapp_taman/screens/admin/admin_settings.dart';
import 'package:mobileapp_taman/screens/admin/admin_setting_screen.dart';

class AppShellAdmin extends StatefulWidget {
  const AppShellAdmin({super.key});

  @override
  State<AppShellAdmin> createState() => _AppShellAdminState();
}

class _AppShellAdminState extends State<AppShellAdmin> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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

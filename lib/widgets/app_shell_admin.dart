import 'package:flutter/material.dart';
import 'app_bar_admin.dart';
import 'bottom_nav_admin.dart';
import 'package:mobileapp_taman/screens/admin/admin_dashboard.dart';
import 'package:mobileapp_taman/screens/admin/admin_settings.dart';

// nếu chưa có, có thể để tạm Container()

class AppShellAdmin extends StatefulWidget {
  const AppShellAdmin({super.key});

  @override
  State<AppShellAdmin> createState() => _AppShellAdminState();
}

class _AppShellAdminState extends State<AppShellAdmin> {
  int _currentIndex = 0;

  // 👉 CÁC BODY CỦA ADMIN
  final List<Widget> _pages = const [
    AdminDashboardBody(),   // index 0 - Quản trị
    AdminSettingsBody(),  // index 1 - Cài đặt
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarAdmin(),

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

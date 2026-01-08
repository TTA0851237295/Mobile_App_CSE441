import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AppBarAdmin extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy chiều cao của status bar (camera, notch)
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      height: preferredSize.height + statusBarHeight,
      width: double.infinity,
      padding: EdgeInsets.only(top: statusBarHeight + 16, bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Tâm An",
            style: TextStyle(
              color: Color(0xFF8B5CF6), // tím chủ đạo
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Quản trị viên",
            style: TextStyle(
              color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF6B7280),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(75);
}

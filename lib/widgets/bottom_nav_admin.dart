import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        border: Border(
          top: BorderSide(
            width: 0.5,
            color: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ⭐ cân 2 tab
        children: [
          _navItem(
            index: 0,
            label: "Quản trị",
            icon: Icons.admin_panel_settings_outlined,
            isDarkMode: isDarkMode,
          ),
          _navItem(
            index: 1,
            label: "Cài đặt",
            icon: Icons.settings_outlined,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String label,
    required IconData icon,
    required bool isDarkMode,
  }) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive
              ? (isDarkMode ? const Color(0xFF8B5CF6) : Colors.black)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? Colors.white
                  : (isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : (isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[700]),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        border: Border(
          top: BorderSide(
            width: 0.1,
            color: isDarkMode ? const Color(0xFF2D2D3D) : const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(index: 0, label: "Check-in", icon: Icons.home_outlined, isDarkMode: isDarkMode),
          _navItem(index: 1, label: "Thống kê", icon: Icons.bar_chart, isDarkMode: isDarkMode),
          _navItem(index: 2, label: "Phân tích", icon: Icons.lightbulb_outline, isDarkMode: isDarkMode),
          _navItem(index: 3, label: "Khác", icon: Icons.settings_outlined, isDarkMode: isDarkMode),
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
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
                  : (isDarkMode ? const Color(0xFF9CA3AF) : Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : (isDarkMode ? const Color(0xFF9CA3AF) : Colors.grey[700]),
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

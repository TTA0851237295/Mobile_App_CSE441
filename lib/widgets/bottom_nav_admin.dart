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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            width: 0.1,
            color: Color.fromARGB(255, 0, 0, 0),
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
          ),
          _navItem(
            index: 1,
            label: "Cài đặt",
            icon: Icons.settings_outlined,
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[700],
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

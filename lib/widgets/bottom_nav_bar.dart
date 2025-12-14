import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: selectedIndex == 0
                ? _buildActiveNavIcon(icon: Icons.home_filled, label: 'Check-in')
                : _buildInactiveNavIcon(icon: Icons.home_outlined, label: 'Check-in'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 1
                ? _buildActiveNavIcon(icon: Icons.bar_chart, label: 'Thống kê')
                : _buildInactiveNavIcon(icon: Icons.bar_chart_outlined, label: 'Thống kê'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 2
                ? _buildActiveNavIcon(icon: Icons.lightbulb, label: 'Phân tích')
                : _buildInactiveNavIcon(icon: Icons.lightbulb_outline, label: 'Phân tích'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 3
                ? _buildActiveNavIcon(icon: Icons.settings, label: 'Khác')
                : _buildInactiveNavIcon(icon: Icons.settings_outlined, label: 'Khác'),
            label: '',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  Widget _buildActiveNavIcon({required IconData icon, required String label}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveNavIcon({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}


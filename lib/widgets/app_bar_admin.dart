import 'package:flutter/material.dart';

class AppBarAdmin extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      decoration: const BoxDecoration(
        color: Colors.white, // 🎯 giống màu BottomNav
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Color(0xFFE5E7EB), // viền xám nhạt
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Tâm An",
            style: TextStyle(
              color: Color(0xFF8B5CF6), // tím chủ đạo
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Quản trị viên",
            style: TextStyle(
              color: Color(0xFF6B7280), // xám nhạt
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      decoration: const BoxDecoration(
        color: Colors.white, // 🎯 GIỐNG MÀU BOTTOM NAV
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.white, // viền nhạt giống footer
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Tâm An",
            style: TextStyle(
              color: Color(0xFF8B5CF6), // tím đậm
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Trợ lý Nhận diện Căng thẳng",
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

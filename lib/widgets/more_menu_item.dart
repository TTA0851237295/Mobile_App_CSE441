import 'package:flutter/material.dart';
import '../config/app_config.dart';

class MoreMenuItem extends StatelessWidget {
  final Widget icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDarkMode;

  const MoreMenuItem({
    Key? key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? const Color(0xFF2D2D3D) : const Color(0x1A000000),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: icon,
              ),
            ),
            const SizedBox(width: 12),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : AppConfig.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF99A1AF),
            ),
          ],
        ),
      ),
    );
  }
}

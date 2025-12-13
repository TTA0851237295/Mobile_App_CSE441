import 'package:flutter/material.dart';
import '../config/app_config.dart';

class MoreMenuItem extends StatelessWidget {
  final Widget icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const MoreMenuItem({
    Key? key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          left: 17.268,
          top: 17.268,
          right: 1.275,
          bottom: 1.275,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0x1A000000),
            width: 1.275,
          ),
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 47.979,
              height: 47.979,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: icon,
              ),
            ),
            const SizedBox(width: 15.993),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppConfig.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 1.992),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConfig.textSecondary,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const SizedBox(width: 15.993),
            SizedBox(
              width: 19.996,
              height: 19.996,
              child: Icon(
                Icons.chevron_right,
                size: 19.996,
                color: const Color(0xFF99A1AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

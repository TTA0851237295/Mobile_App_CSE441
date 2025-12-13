import 'package:flutter/material.dart';
import '../config/app_config.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const StatCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = AppConfig.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 17.268,
          top: 17.268,
          right: 1.275,
          bottom: 1.275,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppConfig.textSecondary,
                      height: 1.43,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: AppConfig.textPrimary,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

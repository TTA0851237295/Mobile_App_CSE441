import 'package:flutter/material.dart';
import '../screens/user/Check_in.dart';

class CheckInReminderDialog extends StatelessWidget {
  final VoidCallback? onCheckIn;
  final VoidCallback? onDismiss;
  final String? message;
  final bool useDialogWrapper;

  const CheckInReminderDialog({
    Key? key,
    this.onCheckIn,
    this.onDismiss,
    this.message,
    this.useDialogWrapper = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header với icon và title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon trái tim trong khung tím
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF9333EA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tâm An',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0A0A0A),
                          ),
                        ),
                        Text(
                          'Bây giờ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message ?? 'Check-in nhanh nhé? 🎉',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0A0A0A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            'Bạn đang cảm thấy thế nào lúc này?',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onDismiss,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Text(
                    'Để sau',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7000B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Check-in ngay',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (useDialogWrapper) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: content,
      );
    }

    return content;
  }

  static void show(BuildContext context, {
    VoidCallback? onCheckIn,
    VoidCallback? onDismiss,
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => CheckInReminderDialog(
        onCheckIn: () {
          Navigator.of(context).pop();
          // Navigate trực tiếp đến màn hình check-in với cảm xúc mặc định
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CheckInDetailScreen(selectedEmotion: 'Bình thường'),
            ),
          );
          onCheckIn?.call();
        },
        onDismiss: () {
          Navigator.of(context).pop();
          onDismiss?.call();
        },
        message: message,
      ),
    );
  }
}


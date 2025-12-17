import 'package:flutter/material.dart';

class PrivacyPolicyModal extends StatelessWidget {
  const PrivacyPolicyModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 392.60,
        height: 681.17,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.27,
              color: Colors.black.withValues(alpha: 0.10),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(0, 10),
              spreadRadius: -3,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Content - Scrollable (bao gồm cả header)
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25.27, 25.27, 25.27, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Chính sách & Điều khoản',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0A0A0A),
                          fontSize: 18,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w700,
                          height: 1,
                          letterSpacing: -0.45,
                        ),
                      ),
                      const SizedBox(height: 5.99),
                      Text(
                        'Quyền riêng tư, trách nhiệm và điều khoản sử dụng',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF495565),
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Content
                  _buildPolicyItem(
                    title: 'Quyền riêng tư',
                    description: 'Tâm An cam kết bảo vệ quyền riêng tư của bạn. Tất cả dữ liệu được lưu trữ 100% trên thiết bị của bạn thông qua LocalStorage. Chúng tôi không thu thập, lưu trữ hoặc chia sẻ bất kỳ thông tin cá nhân nào.',
                  ),
                  const SizedBox(height: 15.99),
                  _buildPolicyItem(
                    title: 'Mục đích sử dụng',
                    description: 'Ứng dụng được thiết kế để hỗ trợ việc theo dõi và cải thiện sức khỏe tinh thần. Đây KHÔNG phải là công cụ chẩn đoán y khoa hoặc thay thế cho tư vấn chuyên môn từ các chuyên gia sức khỏe tâm thần.',
                  ),
                  const SizedBox(height: 15.99),
                  _buildPolicyItem(
                    title: 'Trách nhiệm người dùng',
                    description: 'Bạn chịu trách nhiệm về tính bảo mật của thiết bị và dữ liệu. Nếu bạn đang gặp khủng hoảng sức khỏe tâm thần, vui lòng liên hệ ngay với chuyên gia hoặc đường dây nóng hỗ trợ tâm lý.',
                  ),
                  const SizedBox(height: 15.99),
                  _buildPolicyItem(
                    title: 'Giới hạn trách nhiệm',
                    description: 'Ứng dụng được cung cấp "như hiện tại" không có bất kỳ đảm bảo nào. Chúng tôi không chịu trách nhiệm về bất kỳ thiệt hại nào phát sinh từ việc sử dụng ứng dụng.',
                  ),
                ],
              ),
            ),

            // Close button
            Positioned(
              right: 17.27,
              top: 17.27,
              child: Opacity(
                opacity: 0.70,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 15.99,
                    height: 15.99,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 15.99,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyItem({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        const SizedBox(height: 7.99),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xFF495565),
            fontSize: 16,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';

class UserGuideModal extends StatelessWidget {
  const UserGuideModal({Key? key}) : super(key: key);

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
                        'Hướng dẫn sử dụng Tâm An',
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
                        'Cách sử dụng các tính năng chính của ứng dụng',
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
                  _buildGuideItem(
                    title: '1. Check-in cảm xúc (5 giây)',
                    description: 'Chọn cảm xúc hiện tại, thêm tags nhanh về người, nơi chốn, hoạt động. Tùy chọn: thêm ghi chú, thông tin sức khỏe (giấc ngủ, tập thể dục). Hoàn thành trong 5 giây!',
                  ),
                  const SizedBox(height: 15.99),
                  _buildGuideItem(
                    title: '2. Dashboard thống kê',
                    description: 'Xem xu hướng cảm xúc theo thời gian, biểu đồ phân bố, và các thống kê chi tiết về tâm trạng của bạn.',
                  ),
                  const SizedBox(height: 15.99),
                  _buildGuideItem(
                    title: '3. Tương quan & Phân tích AI',
                    description: 'Khám phá patterns ẩn: Người nào làm bạn vui? Hoạt động nào giảm căng thẳng? Thời điểm nào bạn cảm thấy tốt nhất? AI phân tích và đưa ra gợi ý cá nhân hóa.',
                  ),
                  const SizedBox(height: 15.99),
                  _buildGuideItem(
                    title: '4. Mục tiêu',
                    description: 'Đặt và theo dõi mục tiêu sức khỏe tinh thần. Hệ thống tự động tính toán tiến độ từ check-in và đưa ra gợi ý hành động thông minh.',
                  ),
                  const SizedBox(height: 15.99),
                  _buildGuideItem(
                    title: '5. Nhật ký',
                    description: 'Xem lại lịch sử check-in chi tiết, tìm kiếm theo ngày, cảm xúc, tags để hiểu rõ hơn về hành trình của bạn.',
                  ),
                  const SizedBox(height: 15.99),
                  _buildGuideItem(
                    title: '6. Cài đặt',
                    description: 'Cá nhân hóa trải nghiệm: bật thông báo nhắc nhở, chế độ tối, xuất dữ liệu, đổi mật khẩu, và nhiều tùy chọn khác.',
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

  Widget _buildGuideItem({
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
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
      ],
    );
  }
}


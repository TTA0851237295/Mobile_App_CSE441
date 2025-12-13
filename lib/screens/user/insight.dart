import 'package:flutter/material.dart';

/// ===============================
///  MÀN HÌNH PHÂN TÍCH (INSIGHTS)
/// ===============================
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InsightsContent();
  }
}


/// ===============================
///  PHẦN NỘI DUNG CHÍNH
/// ===============================
class _InsightsContent extends StatelessWidget {
  const _InsightsContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== TIÊU ĐỀ =====
          const Text(
            'Phân tích AI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tâm An đã phân tích 28 check-in trong 30 ngày qua',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),

          // ===== CARD LƯU Ý =====
          _InfoNoteCard(),

          const SizedBox(height: 16),

          // ===== CÁC KHỐI TƯƠNG QUAN =====
          _CorrelationCard(
            emoji: '🎯',
            title: 'Tương quan Hoạt động',
            reliabilityText: '86% tin cậy',
            reliabilityColor: const Color(0xFF00A63E),
            reliabilityBorderColor: const Color(0xFFB8F7CF),
            description:
                'Tâm An nhận thấy: 86% các lần bạn check-in cảm xúc tiêu cực đều liên quan đến hoạt động [Họp]. Có thể đây là một tác nhân gây căng thẳng cho bạn.',
            chipLabel: 'Tương quan Hoạt động',
          ),
          const SizedBox(height: 12),

          _CorrelationCard(
            emoji: '👥',
            title: 'Tương quan Con người',
            reliabilityText: '100% tin cậy',
            reliabilityColor: const Color(0xFF00A63E),
            reliabilityBorderColor: const Color(0xFFB8F7CF),
            description:
                'Bạn có vẻ tích cực hơn khi ở cùng [Bạn bè] (100% check-in tích cực). Ngược lại, cảm xúc tiêu cực tăng cao khi ở với [Sếp] (100%).',
            chipLabel: 'Tương quan Con người',
          ),
          const SizedBox(height: 12),

          _CorrelationCard(
            emoji: '⏰',
            title: 'Tương quan Thời gian',
            reliabilityText: '100% tin cậy',
            reliabilityColor: const Color(0xFF00A63E),
            reliabilityBorderColor: const Color(0xFFB8F7CF),
            description:
                'Tâm An phát hiện: Cảm xúc tiêu cực của bạn thường xuất hiện vào Thứ Năm (100%). Bạn thường cảm thấy căng thẳng vào khoảng 10h (100%).',
            chipLabel: 'Tương quan Thời gian',
          ),
          const SizedBox(height: 12),

          _CorrelationCard(
            emoji: '📍',
            title: 'Tương quan Địa điểm',
            reliabilityText: '83% tin cậy',
            reliabilityColor: const Color(0xFFD08700),
            reliabilityBorderColor: const Color(0xFFFEEF85),
            description:
                '83% các lần check-in tiêu cực của bạn xảy ra tại [Công ty]. Môi trường này có thể đang ảnh hưởng đến tâm trạng của bạn.',
            chipLabel: 'Tương quan Địa điểm',
          ),
          const SizedBox(height: 12),

          _CorrelationCard(
            emoji: '💤',
            title: 'Tương quan Sức khỏe - Giấc ngủ',
            reliabilityText: '90% tin cậy',
            reliabilityColor: const Color(0xFF00A63E),
            reliabilityBorderColor: const Color(0xFFB8F7CF),
            description:
                'Những ngày bạn ngủ ít hơn 6 tiếng, số lần check-in "Giận dữ" của bạn tăng lên đáng kể. Giấc ngủ đầy đủ rất quan trọng cho sức khỏe tinh thần.',
            chipLabel: 'Tương quan Sức khỏe',
          ),

          const SizedBox(height: 20),

          // ===== MẸO PHÂN TÍCH TỐT HƠN =====
          const _TipsCard(),
          const SizedBox(height: 20),

          // ===== LỜI KHUYÊN SỨC KHỎE TINH THẦN =====
          const _MentalHealthSection(),
        ],
      ),
    );
  }
}

/// ===============================
///  CARD LƯU Ý
/// ===============================
class _InfoNoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAF5FE),
            Color(0xFFFCF1F7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.25,
          color: const Color(0xFFE9D4FF),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text(
            '🧠',
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF495565),
                ),
                children: [
                  TextSpan(
                    text: 'Lưu ý: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Các phân tích dưới đây dựa trên dữ liệu check-in của bạn. '
                        'Độ chính xác tăng theo số lượng check-in. Đây chỉ là công cụ hỗ trợ nhận thức, '
                        'không thay thế tư vấn y tế chuyên nghiệp.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
///  CARD TƯƠNG QUAN
/// ===============================
class _CorrelationCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String reliabilityText;
  final Color reliabilityColor;
  final Color reliabilityBorderColor;
  final String description;
  final String chipLabel;

  const _CorrelationCard({
    required this.emoji,
    required this.title,
    required this.reliabilityText,
    required this.reliabilityColor,
    required this.reliabilityBorderColor,
    required this.description,
    required this.chipLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.25,
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header: icon + title + chip tin cậy
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: reliabilityColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    width: 1.25,
                    color: reliabilityBorderColor,
                  ),
                ),
                child: Text(
                  reliabilityText,
                  style: TextStyle(
                    fontSize: 12,
                    color: reliabilityColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              chipLabel,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
///  CARD: MẸO PHÂN TÍCH TỐT HƠN
/// ===============================
class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.25,
          color: const Color(0xFFBFDBFE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Mẹo để có phân tích tốt hơn',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D4ED8),
            ),
          ),
          SizedBox(height: 8),
          _TipsBullet('Check-in ít nhất 2–3 lần mỗi ngày'),
          _TipsBullet('Chọn đầy đủ các tags (vị trí, hoạt động, người cùng)'),
          _TipsBullet('Trung thực với cảm xúc của bạn'),
          _TipsBullet('Kiên trì check-in trong ít nhất 2 tuần'),
        ],
      ),
    );
  }
}

class _TipsBullet extends StatelessWidget {
  final String text;
  const _TipsBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '•  ',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF1D4ED8),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1D4ED8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
///  LỜI KHUYÊN SỨC KHỎE TINH THẦN
/// ===============================
class _MentalHealthSection extends StatelessWidget {
  const _MentalHealthSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              '❤',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFDB2777),
              ),
            ),
            SizedBox(width: 6),
            Text(
              'Lời khuyên Sức khỏe Tinh thần',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFFBE123C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Dựa trên trạng thái cảm xúc của bạn (Vui vẻ), đây là một số lời khuyên hữu ích:',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        const _AdviceCard(
          emoji: '😊',
          title: 'Viết nhật ký cảm ơn',
          description:
              'Mỗi tối trước khi ngủ, hãy viết ra 3 điều bạn cảm thấy biết ơn trong ngày. '
              'Điều này giúp tăng cảm giác hạnh phúc và lạc quan.',
        ),
        const SizedBox(height: 10),
        const _AdviceCard(
          emoji: '😊',
          title: 'Kết nối với người thân',
          description:
              'Dành thời gian trò chuyện với gia đình, bạn bè. '
              'Mối quan hệ xã hội tốt là yếu tố quan trọng cho sức khỏe tinh thần.',
        ),
      ],
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;

  const _AdviceCard({
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1.25,
          color: const Color(0xFFB8F7CF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 26),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0D532B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                width: 1.25,
                color: Colors.black12,
              ),
            ),
            child: const Text(
              'Tăng hạnh phúc',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

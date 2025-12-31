import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/insight_provider.dart';
import '../../providers/checkin_provider.dart';


/// ===============================
///  MÀN HÌNH PHÂN TÍCH (INSIGHTS)
/// ===============================
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch checkins and calculate insights when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final checkinProvider = context.read<CheckinProvider>();
      final insightProvider = context.read<InsightProvider>();
      
      // Fetch latest check-ins first
      await checkinProvider.fetchCheckins();
      
      // Then calculate insights
      await insightProvider.calculateInsights();
    });
  }

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
    return Consumer<InsightProvider>(
      builder: (context, insightProvider, child) {
        final totalCheckins = insightProvider.totalCheckIns;
        final insights = insightProvider.insights;
        final isCalculating = insightProvider.isCalculating;

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
              Text(
                totalCheckins > 0
                    ? 'Tâm An đã phân tích $totalCheckins check-in trong 30 ngày qua'
                    : 'Chưa có dữ liệu để phân tích',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),

              // ===== CARD LƯU Ý =====
              _InfoNoteCard(),

              const SizedBox(height: 16),

              // ===== PHÂN TÍCH THÔNG MINH =====
              _SmartInsightCard(),

              const SizedBox(height: 16),

              // ===== LOADING STATE =====
              if (isCalculating)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

              // ===== CÁC KHỐI TƯƠNG QUAN =====
              if (!isCalculating && insights.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1.25,
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Text(
                          '📊',
                          style: TextStyle(fontSize: 48),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chưa đủ dữ liệu để phân tích',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hãy check-in thường xuyên hơn để Tâm An có thể phân tích tốt hơn!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (!isCalculating && insights.isNotEmpty)
                ...insights.map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CorrelationCard(
                        emoji: insight.emoji,
                        title: insight.title,
                        reliabilityText: insight.reliabilityText,
                        reliabilityColor: insight.reliabilityColor,
                        reliabilityBorderColor: insight.reliabilityBorderColor,
                        description: insight.description,
                        chipLabel: insight.chipLabel,
                      ),
                    )),

              const SizedBox(height: 20),

              // ===== MẸO PHÂN TÍCH TỐT HƠN =====
              const _TipsCard(),
              const SizedBox(height: 20),

              // ===== LỜI KHUYÊN SỨC KHỎE TINH THẦN =====
              const _MentalHealthSection(),
            ],
          ),
        );
      },
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
                  color: reliabilityColor.withValues(alpha: 0.06),
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

/// ===============================
///  CARD PHÂN TÍCH THÔNG MINH
/// ===============================
class _SmartInsightCard extends StatelessWidget {
  const _SmartInsightCard();

  String _getInsightText(BuildContext context) {
    final checkinProvider = context.watch<CheckinProvider>();
    final checkins = checkinProvider.checkins;
    
    if (checkins.isEmpty) {
      return 'Bạn chưa có check-in nào. Hãy bắt đầu ghi lại cảm xúc của mình để nhận phân tích!';
    }

    // Lọc check-in trong 30 ngày qua
    final now = DateTime.now();
    final last30Days = checkins.where((c) {
      final diff = now.difference(c.timestamp).inDays;
      return diff <= 30;
    }).toList();

    if (last30Days.isEmpty) {
      return 'Bạn chưa có check-in nào trong 30 ngày qua.';
    }

    final totalCheckins = last30Days.length;
    
    // Đếm số lượng từng cảm xúc
    final positiveEmotions = ['HAPPY', 'JOYFUL'];
    final negativeEmotions = ['ANXIOUS', 'STRESSED', 'SAD', 'ANGRY'];
    
    int positiveCount = 0;
    int negativeCount = 0;
    int neutralCount = 0;
    Map<String, int> emotionCounts = {};
    
    for (var checkin in last30Days) {
      final emotion = checkin.emotion;
      emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
      
      if (positiveEmotions.contains(emotion)) {
        positiveCount++;
      } else if (negativeEmotions.contains(emotion)) {
        negativeCount++;
      } else {
        neutralCount++;
      }
    }

    final total = positiveCount + negativeCount + neutralCount;
    if (total == 0) return 'Chưa có đủ dữ liệu để phân tích.';

    final positivePercent = (positiveCount / total * 100).round();
    final negativePercent = (negativeCount / total * 100).round();

    // Tìm cảm xúc phổ biến nhất
    String topEmotion = '';
    int maxCount = 0;
    emotionCounts.forEach((emotion, count) {
      if (count > maxCount) {
        maxCount = count;
        topEmotion = emotion;
      }
    });

    // Map emotion to Vietnamese
    final emotionMap = {
      'HAPPY': 'Vui vẻ',
      'JOYFUL': 'Hạnh phúc',
      'NORMAL': 'Bình thường',
      'ANXIOUS': 'Lo lắng',
      'STRESSED': 'Căng thẳng',
      'SAD': 'Buồn bã',
      'ANGRY': 'Giận dữ',
    };
    final topEmotionVi = emotionMap[topEmotion] ?? topEmotion;

    // Tạo insights
    List<String> insights = [];
    
    insights.add('📊 Bạn đã check-in $totalCheckins lần trong 30 ngày qua.');
    
    if (topEmotion.isNotEmpty && maxCount > 0) {
      insights.add('\n\n🎯 Cảm xúc "$topEmotionVi" xuất hiện nhiều nhất với $maxCount lần.');
    }

    if (positivePercent > 60) {
      insights.add('\n\n✨ Tuyệt vời! $positivePercent% thời gian bạn có tâm trạng tích cực. Hãy tiếp tục duy trì nhé!');
    } else if (negativePercent > 60) {
      insights.add('\n\n💙 $negativePercent% thời gian bạn gặp cảm xúc tiêu cực. Hãy chăm sóc bản thân nhiều hơn. Thử các hoạt động thư giãn hoặc nói chuyện với người thân nhé!');
    } else {
      insights.add('\n\n⚖️ Cảm xúc của bạn khá cân bằng với $positivePercent% tích cực và $negativePercent% tiêu cực.');
    }

    // Phân tích xu hướng
    if (last30Days.length >= 7) {
      final recentWeek = last30Days.take(7).toList();
      final recentPositive = recentWeek.where((c) => positiveEmotions.contains(c.emotion)).length;
      final recentNegative = recentWeek.where((c) => negativeEmotions.contains(c.emotion)).length;
      
      if (recentPositive > recentNegative && positivePercent < 50) {
        insights.add('\n\n📈 Tin tốt! Tâm trạng tuần gần đây đang có xu hướng tích cực hơn.');
      } else if (recentNegative > recentPositive && negativePercent < 50) {
        insights.add('\n\n📉 Tuần gần đây có vẻ khó khăn hơn. Hãy dành thời gian nghỉ ngơi và tự chăm sóc bản thân.');
      }
    }

    return insights.join('');
  }

  @override
  Widget build(BuildContext context) {
    final insightText = _getInsightText(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.psychology_outlined,
                color: Color(0xFF8B5CF6),
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                'Phân Tích Thông Minh',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFAF5FF), Color(0xFFF3E8FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9D5FF), width: 1.5),
            ),
            child: Text(
              insightText,
              style: const TextStyle(
                color: Color(0xFF581C87),
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

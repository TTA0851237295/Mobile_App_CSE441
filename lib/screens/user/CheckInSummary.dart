import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/checkin_provider.dart';

class CheckInSummaryScreen extends StatelessWidget {
  final String emotion;
  final String? location;
  final String? activity;
  final String? company;
  final String? note;

  const CheckInSummaryScreen({
    super.key,
    required this.emotion,
    this.location,
    this.activity,
    this.company,
    this.note,
  });

  // Helper để lấy emoji cho location
  String _getLocationEmoji(String location) {
    final map = {
      'Công ty': '🏢',
      'Ở nhà': '🏠',
      'Đang di chuyển': '🚗',
      'Ngoài trời': '🌳',
      'Khác': '📍',
    };
    return map[location] ?? '📍';
  }

  // Helper để lấy emoji cho activity
  String _getActivityEmoji(String activity) {
    final map = {
      'Họp': '💼',
      'Code': '💻',
      'Học bài': '📚',
      'Lướt mạng': '📱',
      'Ăn uống': '🍽️',
      'Tập thể dục': '🏃',
      'Thư giãn': '🧘',
      'Khác': '✨',
    };
    return map[activity] ?? '✨';
  }

  // Helper để lấy emoji cho company
  String _getCompanyEmoji(String company) {
    final map = {
      'Một mình': '🧑',
      'Đồng nghiệp': '👔',
      'Sếp': '👨‍💼',
      'Gia đình': '👨‍👩‍👧‍👦',
      'Bạn bè': '👯',
      'Người yêu': '💑',
      'Khác': '👥',
    };
    return map[company] ?? '👥';
  }

  // Helper để lấy icon cho cảm xúc
  IconData _getEmotionIcon(String emotion) {
    final map = {
      'Vui vẻ': Icons.sentiment_satisfied_alt_outlined,
      'Buồn': Icons.sentiment_dissatisfied_outlined,
      'Lo lắng': Icons.sentiment_dissatisfied_outlined,
      'Căng thẳng': Icons.bolt_outlined,
      'Tức giận': Icons.sentiment_very_dissatisfied_outlined,
      'Bình thường': Icons.sentiment_neutral_outlined,
      'Hạnh phúc': Icons.sentiment_very_satisfied_outlined,
      'Mệt mỏi': Icons.bedtime_outlined,
      'Hứng thú': Icons.star_outlined,
    };
    return map[emotion] ?? Icons.sentiment_satisfied_alt_outlined;
  }

  // Helper để lấy màu cho cảm xúc
  Color _getEmotionColor(String emotion) {
    final map = {
      'Vui vẻ': Colors.green,
      'Buồn': Colors.blue,
      'Lo lắng': Colors.purple,
      'Căng thẳng': Colors.orange,
      'Tức giận': Colors.red,
      'Bình thường': Colors.grey,
      'Hạnh phúc': Colors.yellow,
      'Mệt mỏi': Colors.blueGrey,
      'Hứng thú': Colors.pink,
    };
    return map[emotion] ?? Colors.purple;
  }

  // Helper để lấy màu nền cho cảm xúc
  Color _getEmotionBgColor(String emotion) {
    final map = {
      'Vui vẻ': const Color(0xFFDCFCE7),
      'Buồn': const Color(0xFFDBEAFE),
      'Lo lắng': const Color(0xFFF2E7FE),
      'Căng thẳng': const Color(0xFFFFEDD4),
      'Tức giận': const Color(0xFFFEE2E2),
      'Bình thường': const Color(0xFFF3F4F6),
      'Hạnh phúc': const Color(0xFFFEF9C3),
      'Mệt mỏi': const Color(0xFFE0E7FF),
      'Hứng thú': const Color(0xFFFCE7F3),
    };
    return map[emotion] ?? const Color(0xFFF2E7FE);
  }

  // Helper để tạo lời khuyên dựa trên cảm xúc và nguyên nhân
  String _getPersonalizedAdvice() {
    // Lời khuyên dựa trên cảm xúc
    final emotionAdvice = {
      'Vui vẻ': 'Thật tuyệt khi bạn đang cảm thấy vui vẻ! Hãy tận hưởng khoảnh khắc này và chia sẻ năng lượng tích cực với những người xung quanh nhé! 😊',
      'Buồn': 'Không sao đâu, buồn là cảm xúc bình thường. Hãy cho phép bản thân được cảm nhận và thử nói chuyện với ai đó bạn tin tưởng. Mọi chuyện rồi sẽ qua thôi. 💙',
      'Lo lắng': 'Bạn có vẻ lo lắng. Hãy thử kỹ thuật hít thở 4-7-8: hít vào 4 giây, nín thở 7 giây, thở ra 8 giây. Mọi việc sẽ ổn thôi! 🧘‍♀️',
      'Căng thẳng': 'Căng thẳng có thể ảnh hưởng đến sức khỏe. Hãy nghỉ ngơi 5-10 phút, đi dạo hoặc nghe nhạc nhẹ để giảm áp lực nhé! 🎵',
      'Tức giận': 'Khi tức giận, hãy đếm từ 1 đến 10 và hít thở sâu. Tránh đưa ra quyết định khi đang trong trạng thái này. Bạn làm được mà! 💪',
      'Bình thường': 'Cảm giác bình thường cũng rất tốt! Đây là lúc tốt để lập kế hoạch hoặc làm những việc bạn thích. 😌',
      'Hạnh phúc': 'Tuyệt vời! Hạnh phúc là điều đáng trân trọng. Hãy ghi lại những gì khiến bạn hạnh phúc để nhớ lại khi cần nhé! ✨',
      'Mệt mỏi': 'Cơ thể bạn đang cần nghỉ ngơi. Hãy ngủ đủ giấc, uống nước và tránh làm việc quá sức. Sức khỏe là quan trọng nhất! 😴',
      'Hứng thú': 'Năng lượng tích cực! Hãy tận dụng trạng thái này để làm những việc bạn đam mê và sáng tạo! 🌟',
    };

    String advice = emotionAdvice[emotion] ?? 'Hãy dành thời gian chăm sóc bản thân và lắng nghe cảm xúc của mình nhé! 🌸';

    // Thêm lời khuyên dựa trên nguyên nhân
    List<String> contextAdvice = [];

    if (location != null) {
      if (location == 'Ở nhà' && (emotion == 'Lo lắng' || emotion == 'Buồn')) {
        contextAdvice.add('Ở nhà có thể khiến bạn cảm thấy cô đơn. Hãy thử gọi điện cho bạn bè hoặc ra ngoài đi dạo.');
      } else if (location == 'Công ty' && emotion == 'Căng thẳng') {
        contextAdvice.add('Công việc có thể gây áp lực. Hãy nghỉ giải lao 5-10 phút mỗi giờ.');
      }
    }

    if (activity != null) {
      if (activity == 'Lướt mạng' && (emotion == 'Lo lắng' || emotion == 'Buồn')) {
        contextAdvice.add('Việc lướt mạng quá nhiều có thể ảnh hưởng tiêu cực. Hãy thử đọc sách hoặc đi dạo thay thế.');
      } else if (activity == 'Code' && emotion == 'Căng thẳng') {
        contextAdvice.add('Code lâu có thể gây mệt mỏi. Hãy áp dụng kỹ thuật Pomodoro: 25 phút làm, 5 phút nghỉ.');
      } else if (activity == 'Tập thể dục' && emotion == 'Vui vẻ') {
        contextAdvice.add('Tập thể dục giúp bạn vui vẻ! Hãy duy trì thói quen này nhé.');
      }
    }

    if (company != null) {
      if (company == 'Một mình' && (emotion == 'Lo lắng' || emotion == 'Buồn')) {
        contextAdvice.add('Thời gian một mình cũng cần thiết, nhưng đừng quên kết nối với người thân và bạn bè.');
      } else if (company == 'Sếp' && emotion == 'Căng thẳng') {
        contextAdvice.add('Gặp sếp có thể gây căng thẳng. Hãy chuẩn bị trước và tự tin vào khả năng của mình.');
      } else if ((company == 'Gia đình' || company == 'Bạn bè') && emotion == 'Vui vẻ') {
        contextAdvice.add('Thật tuyệt khi có thời gian với người thân! Những khoảnh khắc này rất quý giá.');
      }
    }

    // Kết hợp lời khuyên
    if (contextAdvice.isNotEmpty) {
      return '${contextAdvice.join(' ')} $advice';
    }

    return advice;
  }

  @override
  Widget build(BuildContext context) {
    final checkInProvider = Provider.of<CheckInProvider>(context);
    final todayCount = checkInProvider.getTodayCheckInCount();
    final personalizedAdvice = _getPersonalizedAdvice();

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxWidth: 420),
          margin: const EdgeInsets.symmetric(vertical: 40),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.67,
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
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tổng kết hôm nay',
                              style: TextStyle(
                                color: Color(0xFF0A0A0A),
                                fontSize: 18,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.45,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Bạn đã check-in $todayCount lần trong ngày hôm nay',
                              style: const TextStyle(
                                color: Color(0xFF495565),
                                fontSize: 14,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Dominant Emotion Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, 0.00),
                        end: Alignment(1.00, 1.00),
                        colors: [Color(0xFFFAF5FE), Color(0xFFFCF1F7)],
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.67, color: Color(0xFFE9D4FF)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cảm xúc vừa chọn',
                          style: TextStyle(
                            color: Color(0xFF0A0A0A),
                            fontSize: 16,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: ShapeDecoration(
                                color: _getEmotionBgColor(emotion),
                                shape: const CircleBorder(),
                              ),
                              child: Icon(
                                _getEmotionIcon(emotion),
                                color: _getEmotionColor(emotion),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  emotion,
                                  style: const TextStyle(
                                    color: Color(0xFF0A0A0A),
                                    fontSize: 16,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  location != null ? 'Tại: $location' : 'Không rõ địa điểm',
                                  style: const TextStyle(
                                    color: Color(0xFF495565),
                                    fontSize: 14,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Advice Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, 0.00),
                        end: Alignment(1.00, 1.00),
                        colors: [Color(0xFFFFFBEA), Color(0xFFFFF7EC)],
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.67, color: Color(0xFFFDE585)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lời khuyên từ Tâm An',
                          style: TextStyle(
                            color: Color(0xFF0A0A0A),
                            fontSize: 16,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          personalizedAdvice,
                          style: const TextStyle(
                            color: Color(0xFF354152),
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                            height: 1.63,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Analysis Card
                  if (location != null || activity != null || company != null || note != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.67, color: Colors.black.withValues(alpha: 0.10)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phân tích nguyên nhân',
                            style: TextStyle(
                              color: Color(0xFF0A0A0A),
                              fontSize: 16,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (location != null) ...[
                            _buildAnalysisRow('Địa điểm:', location!, const Color(0xFFEFF6FF), Icons.location_on, const Color(0xFF3B82F6), _getLocationEmoji(location!)),
                            const SizedBox(height: 12),
                          ],
                          if (activity != null) ...[
                            _buildAnalysisRow('Hoạt động:', activity!, const Color(0xFFF0FDF4), Icons.bolt, const Color(0xFF10B981), _getActivityEmoji(activity!)),
                            const SizedBox(height: 12),
                          ],
                          if (company != null) ...[
                            _buildAnalysisRow('Đồng hành:', company!, const Color(0xFFFAF5FF), Icons.people, const Color(0xFF8B5CF6), _getCompanyEmoji(company!)),
                            const SizedBox(height: 12),
                          ],
                          if (note != null) ...[
                            _buildAnalysisRow('Ghi chú:', note!, const Color(0xFFFFF7EC), Icons.edit_note, const Color(0xFFF59E0B), '📝'),
                          ],
                        ],
                      ),
                    ),
                  if (location != null || activity != null || company != null || note != null)
                    const SizedBox(height: 16),
                  const SizedBox(height: 16),

                  // History Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.67, color: Colors.black.withValues(alpha: 0.10)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lịch sử check-in hôm nay',
                          style: TextStyle(
                            color: Color(0xFF0A0A0A),
                            fontSize: 16,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...checkInProvider.getTodayCheckIns().map((checkIn) {
                          final timeFormat = DateFormat('HH:mm');
                          final hasNote = checkIn.note != null && checkIn.note!.isNotEmpty;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildHistoryItem(
                              checkIn.emotion,
                              timeFormat.format(checkIn.timestamp),
                              _getEmotionBgColor(checkIn.emotion),
                              hasNote,
                              _getEmotionIcon(checkIn.emotion),
                              _getEmotionColor(checkIn.emotion),
                            ),
                          );
                        }).toList(),
                        if (checkInProvider.getTodayCheckIns().isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'Chưa có check-in nào hôm nay',
                                style: TextStyle(
                                  color: Color(0xFF697282),
                                  fontSize: 14,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Close Button
                  InkWell(
                    onTap: () {
                      // Lưu lời khuyên vào provider
                      checkInProvider.setLatestAdvice(personalizedAdvice);
                      // Trả về true để Check_in.dart hiển thị reminder dialog
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 36,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF030213),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Center(
                        child: Text(
                          'Đóng',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisRow(String label, String value, Color bgColor, IconData labelIcon, Color iconColor, String valueEmoji) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(labelIcon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 14,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: ShapeDecoration(
              color: const Color(0xFFECEEF2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              '$valueEmoji $value',
              style: const TextStyle(
                color: Color(0xFF030213),
                fontSize: 12,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
      String emotion,
      String time,
      Color bgColor,
      bool hasNote,
      IconData emotionIcon,
      Color iconColor,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        color: const Color(0xFFF9FAFB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: ShapeDecoration(
              color: bgColor,
              shape: const CircleBorder(),
            ),
            child: Icon(
              emotionIcon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: hasNote ? 3 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emotion,
                  style: const TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 14,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF697282),
                    fontSize: 12,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (hasNote) ...[
            const SizedBox(width: 8),
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.67, color: Colors.black.withValues(alpha: 0.10)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Có ghi chú',
                  style: TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 12,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
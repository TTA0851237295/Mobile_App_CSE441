import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng kết hôm nay',
                              style: TextStyle(
                                color: Color(0xFF0A0A0A),
                                fontSize: 18,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.45,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Bạn đã check-in 3 lần trong ngày hôm nay',
                              style: TextStyle(
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
                              decoration: const ShapeDecoration(
                                color: Color(0xFFF2E7FE),
                                shape: CircleBorder(),
                              ),
                              child: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.purple, size: 24),
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
                                  style: TextStyle(
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lời khuyên từ Tâm An',
                          style: TextStyle(
                            color: Color(0xFF0A0A0A),
                            fontSize: 16,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bạn có vẻ lo lắng do môi trường ở nhà, việc sử dụng mạng xã hội, thời gian một mình. Hãy thử kỹ thuật hít thở 4-7-8: hít vào 4 giây, nín thở 7 giây, thở ra 8 giây. Mọi việc sẽ ổn thôi! 🧘‍♀️',
                          style: TextStyle(
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
                        _buildHistoryItem(
                          'Vui vẻ',
                          '10:14',
                          const Color(0xFFDCFCE7),
                          false,
                          Icons.sentiment_satisfied_alt_outlined,
                          Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _buildHistoryItem(
                          'Căng thẳng',
                          '04:52',
                          const Color(0xFFFFEDD4),
                          true,
                          Icons.bolt_outlined,
                          Colors.orange,
                        ),
                        const SizedBox(height: 8),
                        _buildHistoryItem(
                          'Lo lắng',
                          '07:52',
                          const Color(0xFFF2E7FE),
                          true,
                          Icons.sentiment_dissatisfied_outlined,
                          Colors.purple,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Close Button
                  InkWell(
                    onTap: () {
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../models/check_in.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/stat_card.dart';
import '../../utils/helpers.dart';
import '../../providers/checkin_provider.dart';
import '../../providers/theme_provider.dart';

class JournalScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const JournalScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String? selectedDate;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CheckinProvider>().fetchCheckins();
    });
  }

  List<String> _availableDates(List<CheckIn> checkIns) {
    final dates = ['Tất cả'];
    final uniqueDates = <String>{};

    for (var checkIn in checkIns) {
      uniqueDates.add(Helpers.formatDate(checkIn.timestamp));
    }

    dates.addAll(uniqueDates.toList()..sort((a, b) => b.compareTo(a)));
    return dates;
  }

  List<CheckIn> _filteredCheckIns(List<CheckIn> checkIns) {
    if (selectedDate == null || selectedDate == 'Tất cả') {
      return checkIns;
    }

    return checkIns.where((checkIn) {
      return Helpers.formatDate(checkIn.timestamp) == selectedDate;
    }).toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckinProvider>(
      builder: (context, checkinProvider, child) {
        if (checkinProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final checkIns = checkinProvider.checkins;
        final filteredCheckIns = _filteredCheckIns(checkIns);
        final availableDates = _availableDates(checkIns);

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () => checkinProvider.fetchCheckins(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _buildTitle(),
                const SizedBox(height: 16),
                _buildDateFilter(availableDates),
                const SizedBox(height: 16),
                _buildStatCard(filteredCheckIns),
                const SizedBox(height: 16),
                _buildCheckInList(filteredCheckIns),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: AppConfig.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'Quay lại',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppConfig.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nhật ký Cảm xúc',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Xem lại lịch sử cảm xúc của bạn',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilter(List<String> availableDates) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: availableDates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = availableDates[index];
          final isSelected = selectedDate == date || (selectedDate == null && date == 'Tất cả');

          return _buildDateChip(date, isSelected);
        },
      ),
    );
  }

  Widget _buildDateChip(String date, bool isSelected) {
    final bg = isSelected ? const Color(0xFF020617) : Colors.white;
    final fg = isSelected ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.08),
            width: 1.25,
          ),
        ),
        child: Center(
          child: Text(
            date,
            style: TextStyle(
              color: fg,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(List<CheckIn> filteredCheckIns) {
    return StatCard(
      icon: Icons.calendar_today_outlined,
      label: 'Tổng số check-in',
      value: '${filteredCheckIns.length}',
      iconColor: AppConfig.primaryColor,
    );
  }

  Widget _buildCheckInList(List<CheckIn> filteredCheckIns) {
    if (filteredCheckIns.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'Không có check-in nào',
            style: TextStyle(
              fontSize: 16,
              color: AppConfig.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: filteredCheckIns.map((checkIn) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCheckInCard(checkIn),
        );
      }).toList(),
    );
  }

  Widget _buildCheckInCard(CheckIn checkIn) {
    final emotionStyle = CheckIn.getEmotionStyle(checkIn.emotion);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0x1A000000),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Avatar với icon cảm xúc giống màn hình check-in
              Container(
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFAF5FF),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1.27,
                      color: Color(0xFFE9D4FF),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: _getEmotionIconWidget(checkIn.emotion),
                ),
              ),
              const SizedBox(width: 12),

              // Emotion Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TagChip(
                      label: emotionStyle.label,
                      color: emotionStyle.color,
                      backgroundColor: emotionStyle.backgroundColor,
                      borderColor: emotionStyle.borderColor,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Helpers.formatDateTime(checkIn.timestamp),
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

              // Delete Button
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () => _showDeleteDialog(checkIn),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Color(0xFFE7000B),
                  ),
                ),
              ),
            ],
          ),

          // Context Info (location, activity, people)
          if (checkIn.location != null || checkIn.activity != null || checkIn.people != null) ...[
            const SizedBox(height: 12),
            if (checkIn.location != null)
              _buildContextItem(Icons.location_on_outlined, '${_getLocationEmoji(checkIn.location!)} ${checkIn.location!}'),
            if (checkIn.activity != null)
              _buildContextItem(Icons.flash_on_outlined, '${_getActivityEmoji(checkIn.activity!)} ${checkIn.activity!}'),
            if (checkIn.people != null)
              _buildContextItem(Icons.people_outline, '${_getPeopleEmoji(checkIn.people!)} ${checkIn.people!}'),
          ],

          // Note
          if (checkIn.note != null && checkIn.note!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
              decoration: ShapeDecoration(
                color: const Color(0xFFF9FAFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 16,
                    color: const Color(0xFF354152),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      checkIn.note!,
                      style: const TextStyle(
                        color: Color(0xFF354152),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                        height: 1.43,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContextItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF354152),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF354152),
              fontSize: 14,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  // Xóa hàm _buildContextRow không dùng nữa
  String _getLocationEmoji(String location) {
    switch (location.toLowerCase()) {
      case 'ở nhà':
        return '🏠';
      case 'công ty':
        return '🏢';
      case 'đang di chuyển':
        return '🚗';
      case 'ngoài trời':
        return '🌳';
      default:
        return '📍';
    }
  }

  String _getActivityEmoji(String activity) {
    switch (activity.toLowerCase()) {
      case 'họp':
        return '📋';
      case 'code':
        return '💻';
      case 'học bài':
        return '📚';
      case 'lướt mạng':
        return '📱';
      case 'ăn uống':
        return '🍽️';
      case 'tập thể dục':
        return '🏃';
      case 'thư giãn':
        return '😌';
      default:
        return '⚡';
    }
  }

  String _getPeopleEmoji(String people) {
    switch (people.toLowerCase()) {
      case 'một mình':
        return '🧑';
      case 'đồng nghiệp':
        return '👔';
      case 'sếp':
        return '👨‍💼';
      case 'gia đình':
        return '👨‍👩‍👧';
      case 'bạn bè':
        return '👫';
      case 'người yêu':
        return '💑';
      default:
        return '👤';
    }
  }

  // Lấy icon cảm xúc giống màn hình check-in
  Widget _getEmotionIconWidget(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'hạnh phúc':
      case 'happy':
        return const Icon(
          Icons.sentiment_very_satisfied_outlined,
          color: Colors.amber,
          size: 28,
        );
      case 'vui vẻ':
      case 'joy':
        return const Icon(
          Icons.sentiment_satisfied_alt_outlined,
          color: Colors.green,
          size: 28,
        );
      case 'bình thường':
      case 'neutral':
        return const Icon(
          Icons.sentiment_neutral_outlined,
          color: Colors.grey,
          size: 28,
        );
      case 'buồn':
      case 'sad':
        return const Icon(
          Icons.thunderstorm_outlined,
          color: Colors.blue,
          size: 28,
        );
      case 'lo lắng':
      case 'worried':
      case 'anxious':
        return const Icon(
          Icons.sentiment_dissatisfied_outlined,
          color: Colors.purple,
          size: 28,
        );
      case 'căng thẳng':
      case 'stressed':
        return const Icon(
          Icons.bolt_outlined,
          color: Colors.orange,
          size: 28,
        );
      case 'giận dữ':
      case 'angry':
        return const Icon(
          Icons.sentiment_very_dissatisfied,
          color: Colors.red,
          size: 28,
        );
      default:
        return const Icon(
          Icons.sentiment_neutral_outlined,
          color: Colors.grey,
          size: 28,
        );
    }
  }

  String _getEmotionEmoji(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'lo lắng':
      case 'anxious':
      case 'worried':
        return '😟';
      case 'giận dữ':
      case 'angry':
        return '😡';
      case 'căng thẳng':
      case 'stressed':
        return '😰';
      case 'vui vẻ':
      case 'joy':
        return '😊';
      case 'hạnh phúc':
      case 'happy':
        return '😆';
      case 'bình thường':
      case 'neutral':
        return '😐';
      case 'buồn':
      case 'sad':
        return '😢';
      default:
        return '😐';
    }
  }


  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'lo lắng':
      case 'anxious':
      case 'worried':
        return Icons.mood_bad; // Mặt buồn/lo lắng
      case 'giận dữ':
      case 'angry':
        return Icons.sentiment_very_dissatisfied; // Mặt rất tức giận
      case 'căng thẳng':
      case 'stressed':
        return Icons.bolt; // Tia chớp
      case 'vui vẻ':
      case 'happy':
      case 'hạnh phúc':
        return Icons.mood; // Mặt cười rộng (mood icon)
      case 'bình thường':
      case 'neutral':
        return Icons.sentiment_neutral; // Mặt bình thường
      case 'buồn':
      case 'sad':
        return Icons.sentiment_dissatisfied; // Mặt buồn
      default:
        return Icons.circle;
    }
  }

  void _showDeleteDialog(CheckIn checkIn) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa check-in'),
        content: const Text('Bạn có chắc chắn muốn xóa check-in này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final checkinProvider = context.read<CheckinProvider>();
              final success = await checkinProvider.deleteCheckin(checkIn.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          success ? Icons.check_circle : Icons.error,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(success ? 'Đã xóa check-in' : 'Lỗi khi xóa check-in')),
                      ],
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Color(0xFFE7000B)),
            ),
          ),
        ],
      ),
    );
  }
}

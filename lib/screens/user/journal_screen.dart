import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../models/check_in.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/stat_card.dart';
import '../../utils/helpers.dart';
import '../../providers/checkin_provider.dart';

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
              // Emotion Icon Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: emotionStyle.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: emotionStyle.borderColor,
                    width: 1.25,
                  ),
                ),
                child: Icon(
                  _getEmotionIcon(checkIn.emotion),
                  size: 24,
                  color: emotionStyle.color,
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
              _buildContextRow(Icons.location_on_outlined, checkIn.location!),
            if (checkIn.activity != null)
              _buildContextRow(Icons.local_activity_outlined, checkIn.activity!),
            if (checkIn.people != null)
              _buildContextRow(Icons.people_outline, checkIn.people!),
          ],

          // Note
          if (checkIn.note != null && checkIn.note!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💭',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      checkIn.note!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppConfig.textPrimary,
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

  Widget _buildContextRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppConfig.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppConfig.textPrimary,
                height: 1.43,
              ),
            ),
          ),
        ],
      ),
    );
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
              // Refresh data from server
              await context.read<CheckinProvider>().fetchCheckins();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa check-in')),
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

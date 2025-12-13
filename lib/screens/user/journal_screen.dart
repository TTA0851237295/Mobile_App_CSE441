import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/check_in.dart';
import '../../widgets/tag_chip.dart';
import '../../widgets/stat_card.dart';
import '../../utils/helpers.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  String? selectedDate;
  final ScrollController _scrollController = ScrollController();

  // Mock data - Replace with actual data from provider
  final List<CheckIn> _checkIns = [
    CheckIn(
      id: '1',
      userId: 'user1',
      emotion: 'Giận dữ',
      timestamp: DateTime(2025, 12, 6, 23, 30),
    ),
    CheckIn(
      id: '2',
      userId: 'user1',
      emotion: 'Căng thẳng',
      timestamp: DateTime(2025, 12, 6, 23, 24),
    ),
  ];

  List<String> get _availableDates {
    final dates = ['Tất cả'];
    final uniqueDates = <String>{};

    for (var checkIn in _checkIns) {
      uniqueDates.add(Helpers.formatDate(checkIn.timestamp));
    }

    dates.addAll(uniqueDates.toList()..sort((a, b) => b.compareTo(a)));
    return dates;
  }

  List<CheckIn> get _filteredCheckIns {
    if (selectedDate == null || selectedDate == 'Tất cả') {
      return _checkIns;
    }

    return _checkIns.where((checkIn) {
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
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTitle(),
                  const SizedBox(height: 24),
                  _buildDateFilter(),
                  const SizedBox(height: 24),
                  _buildStatCard(),
                  const SizedBox(height: 16),
                  _buildCheckInList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: AppConfig.primaryColor,
              ),
              const SizedBox(width: 8),
              const Text(
                'Quay lại',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppConfig.primaryColor,
                  height: 1.5,
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
            fontWeight: FontWeight.w400,
            color: AppConfig.textPrimary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Xem lại lịch sử cảm xúc của bạn',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppConfig.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDateFilter() {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _availableDates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = _availableDates[index];
          final isSelected = selectedDate == date || (selectedDate == null && date == 'Tất cả');

          return _buildDateChip(date, isSelected);
        },
      ),
    );
  }

  Widget _buildDateChip(String date, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConfig.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppConfig.borderColor,
            width: 1.275,
          ),
        ),
        child: Center(
          child: Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : AppConfig.textPrimary,
              height: 1.43,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard() {
    return StatCard(
      icon: Icons.calendar_today_outlined,
      label: 'Tổng số check-in',
      value: '${_checkIns.length}',
      iconColor: AppConfig.primaryColor,
    );
  }

  Widget _buildCheckInList() {
    if (_filteredCheckIns.isEmpty) {
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
      children: _filteredCheckIns.map((checkIn) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCheckInCard(checkIn),
        );
      }).toList(),
    );
  }

  Widget _buildCheckInCard(CheckIn checkIn) {
    final emotionStyle = CheckIn.getEmotionStyle(checkIn.emotion);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(21.271),
        child: Row(
          children: [
            // Emotion Icon Container
            Container(
              width: 50.529,
              height: 50.529,
              decoration: BoxDecoration(
                color: emotionStyle.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: emotionStyle.borderColor,
                  width: 1.275,
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
                  const SizedBox(height: 8),
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
            IconButton(
              onPressed: () => _showDeleteDialog(checkIn),
              icon: const Icon(
                Icons.delete_outline,
                size: 16,
                color: Color(0xFFE7000B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'giận dữ':
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'căng thẳng':
      case 'stressed':
        return Icons.bolt;
      case 'vui vẻ':
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'bình thường':
      case 'neutral':
        return Icons.sentiment_neutral;
      case 'buồn':
      case 'sad':
        return Icons.sentiment_dissatisfied;
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
            onPressed: () {
              // TODO: Implement delete logic with provider
              setState(() {
                _checkIns.removeWhere((c) => c.id == checkIn.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa check-in')),
              );
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

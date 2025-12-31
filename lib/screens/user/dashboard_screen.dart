import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/checkin_provider.dart';
import '../../config/app_config.dart';

/// Màn hình chính – tab "Thống kê"
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedFilter = '7 ngày';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Map filter to days parameter
    int? days;
    if (_selectedFilter == '7 ngày') {
      days = 7;
    } else if (_selectedFilter == '30 ngày') {
      days = 30;
    } else {
      days = 3650; // 10 years = all data
    }
    
    // Fetch both stats and checkins for complete data
    await Future.wait([
      context.read<DashboardProvider>().fetchStats(days: days),
      context.read<CheckinProvider>().fetchCheckins(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, CheckinProvider>(
      builder: (context, dashboardProvider, checkinProvider, child) {
        if (dashboardProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, 0.0),
              end: Alignment(1.0, 1.0),
              colors: [
                Color(0xFFEEF5FE),
                Color(0xFFFAF5FE),
                Color(0xFFFCF1F7),
              ],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadData();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _StatsTitleSection(),
                  const SizedBox(height: 16),
                  _FilterRow(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _loadData();
                    },
                  ),
                  const SizedBox(height: 16),
                  _SummaryRow(
                    selectedFilter: _selectedFilter,
                    dashboardProvider: dashboardProvider,
                  ),
                  const SizedBox(height: 16),
                  EmotionDistributionCard(
                    selectedFilter: _selectedFilter,
                    emotionCounts: dashboardProvider.emotionCounts,
                  ),
                  // Chỉ hiển thị biểu đồ cột cho filter "7 ngày"
                  if (_selectedFilter == '7 ngày') ...[
                    const SizedBox(height: 16),
                    _EmotionStackedBarCard(
                      selectedFilter: _selectedFilter,
                      checkinProvider: checkinProvider,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _TopEmotionCard(
                    selectedFilter: _selectedFilter,
                    emotionCounts: dashboardProvider.emotionCounts,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatsTitleSection extends StatelessWidget {
  const _StatsTitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Thống kê Cảm xúc',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Tổng quan về tâm trạng của bạn',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        ),
      ],
    );
  }
}

/// Hàng filter 7 ngày / 30 ngày / Tất cả
class _FilterRow extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const _FilterRow({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterChip(
          label: '7 ngày',
          selected: selectedFilter == '7 ngày',
          onTap: () => onFilterChanged('7 ngày'),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: '30 ngày',
          selected: selectedFilter == '30 ngày',
          onTap: () => onFilterChanged('30 ngày'),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          label: 'Tất cả',
          selected: selectedFilter == 'Tất cả',
          onTap: () => onFilterChanged('Tất cả'),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF020617) : Colors.white;
    final fg = selected ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.black.withValues(alpha: 0.08),
            width: 1.25,
          ),
        ),
        child: Text(label, style: TextStyle(color: fg, fontSize: 14)),
      ),
    );
  }
}

/// 2 card "Tổng check-in" & "Trung bình/ngày"
class _SummaryRow extends StatelessWidget {
  final String selectedFilter;
  final DashboardProvider dashboardProvider;

  const _SummaryRow({
    required this.selectedFilter,
    required this.dashboardProvider,
  });

  @override
  Widget build(BuildContext context) {
    final totalCheckIn = dashboardProvider.totalCheckins.toString();
    final avgPerDay = dashboardProvider.totalCheckins > 0
        ? (dashboardProvider.totalCheckins / (selectedFilter == '7 ngày' ? 7 : selectedFilter == '30 ngày' ? 30 : 365)).toStringAsFixed(1)
        : '0.0';

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.calendar_today_rounded,
            iconBg: const Color(0xFFF5E9FF),
            title: 'Tổng check-in',
            value: totalCheckIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.trending_up_rounded,
            iconBg: const Color(0xFFE5FBEE),
            title: 'Trung bình/ngày',
            value: avgPerDay,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _card(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
//  PHÂN BỐ + CHI TIẾT CẢM XÚC (CARD GỘP CHUNG)
//

class EmotionDistributionCard extends StatelessWidget {
  final String selectedFilter;
  final Map<String, int> emotionCounts;

  const EmotionDistributionCard({
    super.key,
    required this.selectedFilter,
    required this.emotionCounts,
  });

  @override
  Widget build(BuildContext context) {
    if (emotionCounts.isEmpty) {
      return _card(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Chưa có dữ liệu'),
          ),
        ),
      );
    }

    // Parse emotion stats from API
    List<_LegendItem> labels = [];
    List<PieChartSectionData> sections = [];
    
    final colors = {
      'Vui vẻ': const Color(0xFF22C55E),
      'Hạnh phúc': const Color(0xFFEAB308),
      'Bình thường': const Color(0xFF6B7280),
      'Lo lắng': const Color(0xFF8B5CF6),
      'Căng thẳng': const Color(0xFFF97316),
      'Giận dữ': const Color(0xFFEF4444),
      'Buồn': const Color(0xFF3B82F6),
    };

    int total = 0;
    emotionCounts.forEach((key, value) {
      total += value;
    });

    if (total > 0) {
      emotionCounts.forEach((emotionEnum, count) {
        if (count > 0) {
          // Convert enum to Vietnamese
          final emotion = AppConfig.enumToEmotion[emotionEnum] ?? emotionEnum;
          final color = colors[emotion] ?? const Color(0xFF6B7280);
          final percentage = ((count / total) * 100).toStringAsFixed(0);
          
          labels.add(_LegendItem(emotion, color, '$count ($percentage%)'));
          sections.add(
            PieChartSectionData(
              value: count.toDouble(),
              title: '$emotion\n$percentage%',
              color: color,
              radius: 100,
              titleStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              titlePositionPercentageOffset: 1.4,
            ),
          );
        }
      });
    }

    if (labels.isEmpty) {
      return _card(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Chưa có dữ liệu'),
          ),
        ),
      );
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Phân bố Cảm xúc",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // 🔥 Biểu đồ tròn dùng FL CHART
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 0,
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
                sections: sections,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Legend chi tiết phía dưới
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: labels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 12,
              childAspectRatio: 6.5,
            ),
            itemBuilder: (context, index) {
              final item = labels[index];
              return Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${item.label}: ${item.value}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF374151),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LegendItem {
  final String label;
  final Color color;
  final String value;
  const _LegendItem(this.label, this.color, this.value);
}

//
//  BIỂU ĐỒ CỘT STACKED – CẢM XÚC 7 NGÀY
//

class _EmotionStackedBarCard extends StatelessWidget {
  final String selectedFilter;
  final CheckinProvider checkinProvider;

  const _EmotionStackedBarCard({
    required this.selectedFilter,
    required this.checkinProvider,
  });

  @override
  Widget build(BuildContext context) {
    // Color mapping - theo thứ tự emotions
    const colors = [
      Color(0xFF22C55E), // JOY - Vui vẻ
      Color(0xFFEAB308), // HAPPY - Hạnh phúc
      Color(0xFF6B7280), // NEUTRAL - Bình thường
      Color(0xFF8B5CF6), // WORRIED - Lo lắng
      Color(0xFFF97316), // STRESSED - Căng thẳng
      Color(0xFF3B82F6), // SAD - Buồn
      Color(0xFFEF4444), // ANGRY - Giận dữ
    ];

    const labels = [
      'Vui vẻ',
      'Hạnh phúc',
      'Bình thường',
      'Lo lắng',
      'Căng thẳng',
      'Buồn',
      'Giận dữ',
    ];

    const emotionOrder = ['JOY', 'HAPPY', 'NEUTRAL', 'WORRIED', 'STRESSED', 'SAD', 'ANGRY'];

    List<String> days;
    List<List<double>> data;

    // Chỉ hiển thị biểu đồ cột cho filter "7 ngày"
    if (selectedFilter == '7 ngày') {
      // Luôn hiển thị đủ 7 ngày trong tuần
      days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      
      // Tính ngày đầu tuần (T2) và cuối tuần (CN)
      final now = DateTime.now();
      final currentWeekday = now.weekday; // 1=Monday, 7=Sunday
      final monday = now.subtract(Duration(days: currentWeekday - 1));
      
      // Lấy tất cả check-ins trong 7 ngày qua
      final allCheckins = checkinProvider.checkins;
      final startOfWeek = now.subtract(Duration(days: currentWeekday - 1)); // Monday
      final endOfWeek = startOfWeek.add(const Duration(days: 7)); // Next Monday
      
      final weekCheckins = allCheckins.where((checkin) {
        return checkin.timestamp.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
               checkin.timestamp.isBefore(endOfWeek);
      }).toList();
      
      print('DEBUG: Total checkins: ${allCheckins.length}');
      print('DEBUG: Week checkins: ${weekCheckins.length}');
      
      // Map emotion Vietnamese to enum index
      final emotionToIndex = {
        'Vui vẻ': 0,      // JOY
        'Hạnh phúc': 1,   // HAPPY
        'Bình thường': 2, // NEUTRAL
        'Lo lắng': 3,     // WORRIED
        'Căng thẳng': 4,  // STRESSED
        'Buồn bã': 5,     // SAD
        'Giận dữ': 6,     // ANGRY
      };
      
      // Tạo data cho 7 ngày với count của từng emotion
      data = [];
      for (int weekday = 1; weekday <= 7; weekday++) {
        final dayEmotions = List<double>.filled(7, 0.0);
        
        // Filter check-ins cho ngày này
        final dayCheckins = weekCheckins.where((c) => c.timestamp.weekday == weekday).toList();
        
        if (dayCheckins.isNotEmpty) {
          // Count each emotion
          final emotionCounts = <int, int>{};
          for (var checkin in dayCheckins) {
            final emotionIndex = emotionToIndex[checkin.emotion] ?? 2;
            emotionCounts[emotionIndex] = (emotionCounts[emotionIndex] ?? 0) + 1;
          }
          
          // Convert counts to normalized values (0-1 scale)
          final maxCount = emotionCounts.values.fold(0, (max, count) => count > max ? count : max);
          emotionCounts.forEach((index, count) {
            dayEmotions[index] = count / (maxCount > 0 ? maxCount : 1);
          });
          
          print('DEBUG: Weekday $weekday has ${dayCheckins.length} check-ins, emotions: $emotionCounts');
        } else {
          print('DEBUG: Weekday $weekday has no check-ins');
        }
        
        data.add(dayEmotions);
      }
      
      print('DEBUG: Final data: $data');
    } else {
      // 30 ngày hoặc Tất cả - ẨN biểu đồ cột
      days = [];
      data = [];
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chỉ hiển thị biểu đồ cột cho filter "7 ngày"
          if (selectedFilter == '7 ngày') ...[
            Text(
              'Cảm xúc Theo Ngày (${selectedFilter})',
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            // Debug info
            if (days.isNotEmpty)
              Text(
                'Tuần này: ${days.length} ngày',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 11,
                ),
              ),
            const SizedBox(height: 8),
            if (data.isNotEmpty) ...[
              SizedBox(
                height: 160,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomPaint(
                      painter: _StackedBarChartPainter(data, colors),
                      size: Size(constraints.maxWidth, 160),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              // Labels căn chỉnh với cột (có margin trái 30px)
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days
                      .map(
                        (d) => Expanded(
                          child: Text(
                            d,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 6,
                children: List.generate(labels.length, (i) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[i],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(labels[i], style: const TextStyle(fontSize: 11)),
                    ],
                  );
                }),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _StackedBarChartPainter extends CustomPainter {
  final List<List<double>> data;
  final List<Color> colors;

  _StackedBarChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    final leftMargin = 30.0; // Khoảng trống cho trục Y
    final bottomMargin = 5.0;
    final chartWidth = size.width - leftMargin;
    final chartHeight = size.height - bottomMargin;
    
    // Vẽ trục Y (bên trái)
    final axisPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1.5;
    
    canvas.drawLine(
      Offset(leftMargin, 0),
      Offset(leftMargin, chartHeight),
      axisPaint,
    );
    
    // Vẽ trục X (dưới cùng)
    canvas.drawLine(
      Offset(leftMargin, chartHeight),
      Offset(size.width, chartHeight),
      axisPaint,
    );
    
    // Vẽ các mốc trục Y (0, 0.25, 0.5, 0.75, 1.0)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i <= 4; i++) {
      final value = i * 0.25;
      final y = chartHeight - (i * 0.25 * chartHeight);
      
      // Vẽ vạch ngang
      final gridPaint = Paint()
        ..color = const Color(0xFFE5E7EB)
        ..strokeWidth = 0.5;
      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(size.width, y),
        gridPaint,
      );
      
      // Vẽ số
      textPainter.text = TextSpan(
        text: value.toStringAsFixed(1),
        style: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftMargin - textPainter.width - 5, y - textPainter.height / 2),
      );
    }
    
    // Tính toán khoảng cách cho các cột
    final spacing = chartWidth / data.length;
    final barWidth = spacing * 0.6;
    final maxHeight = chartHeight; // Chiều cao tối đa = chiều cao chart

    final paint = Paint()..style = PaintingStyle.fill;

    // Vẽ các cột
    for (int dayIdx = 0; dayIdx < data.length; dayIdx++) {
      final dayEmotions = data[dayIdx];
      final x = leftMargin + (dayIdx * spacing) + (spacing - barWidth) / 2;

      // Tính tổng giá trị để chuẩn hóa nếu > 1
      final totalValue = dayEmotions.fold(0.0, (sum, val) => sum + val);
      final scaleFactor = totalValue > 1.0 ? 1.0 / totalValue : 1.0;

      double accumulated = 0;
      for (int emotionIdx = 0; emotionIdx < dayEmotions.length; emotionIdx++) {
        final value = dayEmotions[emotionIdx];
        if (value <= 0) continue;

        final normalizedValue = value * scaleFactor;
        final segmentHeight = normalizedValue * maxHeight;
        final y = chartHeight - accumulated - segmentHeight;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, segmentHeight),
          const Radius.circular(3),
        );

        paint.color = colors[emotionIdx];
        canvas.drawRRect(rect, paint);
        accumulated += segmentHeight;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StackedBarChartPainter oldDelegate) {
    // Re-paint if data changes
    return true;
  }
}

/// Biểu đồ cột hiển thị cảm xúc theo thống kê
class _EmotionTrendsCard extends StatelessWidget {
  final String selectedFilter;
  final Map<String, int> emotionCounts;

  const _EmotionTrendsCard({
    required this.selectedFilter,
    required this.emotionCounts,
  });

  @override
  Widget build(BuildContext context) {
    if (emotionCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = {
      'Vui vẻ': const Color(0xFF22C55E),
      'Hạnh phúc': const Color(0xFFEAB308),
      'Bình thường': const Color(0xFF6B7280),
      'Lo lắng': const Color(0xFF8B5CF6),
      'Căng thẳng': const Color(0xFFF97316),
      'Giận dữ': const Color(0xFFEF4444),
      'Buồn': const Color(0xFF3B82F6),
    };

    // Convert emotionCounts to bar chart data
    final List<BarChartGroupData> barGroups = [];
    final emotionLabels = <String>[];
    int index = 0;
    
    emotionCounts.forEach((emotionEnum, count) {
      if (count > 0) {
        final emotion = AppConfig.enumToEmotion[emotionEnum] ?? emotionEnum;
        final color = colors[emotion] ?? const Color(0xFF6B7280);
        emotionLabels.add(emotion);
        
        barGroups.add(
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                color: color,
                width: 32,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          ),
        );
        index++;
      }
    });

    if (barGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxY = emotionCounts.values.reduce((a, b) => a > b ? a : b).toDouble();

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê Cảm xúc',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: maxY + 2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${emotionLabels[groupIndex]}\n${rod.toY.toInt()} lần',
                        const TextStyle(color: Colors.white, fontSize: 12),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < emotionLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              emotionLabels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: maxY > 10 ? (maxY / 5).ceilToDouble() : 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B7280),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 10 ? (maxY / 5).ceilToDouble() : 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFE5E7EB),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
//  CẢM XÚC PHỔ BIẾN NHẤT
//

class _TopEmotionCard extends StatelessWidget {
  final String selectedFilter;
  final Map<String, int> emotionCounts;

  const _TopEmotionCard({
    required this.selectedFilter,
    required this.emotionCounts,
  });

  @override
  Widget build(BuildContext context) {
    final colors = {
      'Vui vẻ': const Color(0xFF22C55E),
      'Hạnh phúc': const Color(0xFFEAB308),
      'Bình thường': const Color(0xFF6B7280),
      'Lo lắng': const Color(0xFF8B5CF6),
      'Căng thẳng': const Color(0xFFF97316),
      'Giận dữ': const Color(0xFFEF4444),
    };

    // Parse emotion counts from API
    List<_EmotionSummary> items = [];
    int total = 0;
    
    emotionCounts.forEach((key, value) {
      total += value;
    });

    if (total > 0) {
      emotionCounts.forEach((emotion, count) {
        if (count > 0) {
          // Convert enum to Vietnamese
          final vietnameseEmotion = AppConfig.enumToEmotion[emotion] ?? emotion;
          final color = colors[vietnameseEmotion] ?? const Color(0xFF6B7280);
          final value = count / total;
          items.add(_EmotionSummary(vietnameseEmotion, count, value, color));
        }
      });
      
      // Sort by count descending
      items.sort((a, b) => b.times.compareTo(a.times));
      // Take top 5
      if (items.length > 5) {
        items = items.sublist(0, 5);
      }
    }

    if (items.isEmpty) {
      return _card(
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Chưa có dữ liệu'),
          ),
        ),
      );
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cảm xúc Phổ biến Nhất',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              for (int i = 0; i < items.length; i++)
                _TopEmotionItem(index: i + 1, summary: items[i]),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmotionSummary {
  final String label;
  final int times;
  final double value;
  final Color color;
  const _EmotionSummary(this.label, this.times, this.value, this.color);
}

class _TopEmotionItem extends StatelessWidget {
  final int index;
  final _EmotionSummary summary;

  const _TopEmotionItem({
    required this.index,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFE5E7EB),
            child: Text(
              '$index',
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary.label,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: summary.value.clamp(0.0, 1.0),
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(summary.color),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${summary.times} lần',
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Helper: card trắng bo tròn như Figma
Widget _card({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.black.withValues(alpha: 0.06), width: 1),
    ),
    child: child,
  );
}

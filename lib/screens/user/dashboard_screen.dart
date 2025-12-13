import 'package:flutter/material.dart';
import 'package:mobileapp_taman/widgets/layout/app_shell.dart';
import 'package:fl_chart/fl_chart.dart'; // 👈 THÊM DÒNG NÀY

void main() {
  runApp(const TamAnApp());
}

class TamAnApp extends StatelessWidget {
  const TamAnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tâm An',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFF0F172A), // nền ngoài tối
      ),
      home: const StatisticsScreen(),
    );
  }
}

/// Màn hình chính – tab "Thống kê"
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // background gradient
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _StatsTitleSection(),
            SizedBox(height: 16),
            _FilterRow(),
            SizedBox(height: 16),
            _SummaryRow(),
            SizedBox(height: 16),
            EmotionDistributionCard(),
            SizedBox(height: 16),
            _EmotionStackedBarCard(),
            SizedBox(height: 16),
            _TopEmotionCard(),
          ],
        ),
      ),
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
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _FilterChip(label: '7 ngày', selected: true),
        SizedBox(width: 8),
        _FilterChip(label: '30 ngày'),
        SizedBox(width: 8),
        _FilterChip(label: 'Tất cả'),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF020617) : Colors.white;
    final fg = selected ? Colors.white : const Color(0xFF0F172A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? Colors.transparent : Colors.black.withOpacity(0.08),
          width: 1.25,
        ),
      ),
      child: Text(label, style: TextStyle(color: fg, fontSize: 14)),
    );
  }
}

/// 2 card "Tổng check-in" & "Trung bình/ngày"
class _SummaryRow extends StatelessWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _SummaryCard(
            icon: Icons.calendar_today_rounded,
            iconBg: Color(0xFFF5E9FF),
            title: 'Tổng check-in',
            value: '19',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.trending_up_rounded,
            iconBg: Color(0xFFE5FBEE),
            title: 'Trung bình/ngày',
            value: '2.7',
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
  const EmotionDistributionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_LegendItem> labels = [
      _LegendItem('Vui vẻ', const Color(0xFF22C55E), '4 (21%)'),
      _LegendItem('Hạnh phúc', const Color(0xFFEAB308), '2 (11%)'),
      _LegendItem('Bình thường', const Color(0xFF6B7280), '4 (21%)'),
      _LegendItem('Lo lắng', const Color(0xFF8B5CF6), '2 (11%)'),
      _LegendItem('Căng thẳng', const Color(0xFFF97316), '4 (21%)'),
      _LegendItem('Giận dữ', const Color(0xFFEF4444), '3 (16%)'),
    ];

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

          // 🔥 Biểu đồ donut dùng FL CHART – giống hệt mẫu "Phân loại chi tiêu"
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 55, // tạo donut
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
                sections: [
                  PieChartSectionData(
                    value: 4,
                    title: 'Vui vẻ\n21%',
                    color: const Color(0xFF22C55E),
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF22C55E),
                    ),
                    titlePositionPercentageOffset: 1.4,
                  ),
                  PieChartSectionData(
                    value: 2,
                    title: 'Hạnh phúc\n11%',
                    color: const Color(0xFFEAB308),
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEAB308),
                    ),
                    titlePositionPercentageOffset: 1.4,
                  ),
                  PieChartSectionData(
                    value: 4,
                    title: 'Bình thường\n21%',
                    color: const Color(0xFF6B7280),
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                    titlePositionPercentageOffset: 1.4,
                  ),
                  PieChartSectionData(
                    value: 2,
                    title: 'Lo lắng\n11%',
                    color: const Color(0xFF8B5CF6),
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B5CF6),
                    ),
                    titlePositionPercentageOffset: 1.4,
                  ),
                  PieChartSectionData(
                    value: 4,
                    title: 'Căng thẳng\n21%',
                    color: const Color(0xFFF97316),
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF97316),
                    ),
                    titlePositionPercentageOffset: 1.4,
                  ),
                  PieChartSectionData(
                    value: 3,
                    title: 'Giận dữ\n16%',
                    color: const Color(0xFFEF4444),
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                    titlePositionPercentageOffset: 1.4,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Legend chi tiết phía dưới (giữ nguyên)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: labels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 🔥 2 CỘT
              mainAxisSpacing: 4,
              crossAxisSpacing: 12,
              childAspectRatio: 6.5, // 🔥 Điều chỉnh khoảng cách cho đẹp
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
                      '${item.label}: ${item.text}',
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
  final String text;
  const _LegendItem(this.label, this.color, this.text);
}

//
//  BIỂU ĐỒ CỘT STACKED – CẢM XÚC 7 NGÀY
//

class _EmotionStackedBarCard extends StatelessWidget {
  const _EmotionStackedBarCard();

  @override
  Widget build(BuildContext context) {
    const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

    const colors = [
      Color(0xFFEF4444), // angry
      Color(0xFF8B5CF6), // anxious
      Color(0xFF22C55E), // happy
      Color(0xFFEAB308), // joyful
      Color(0xFF6B7280), // neutral
      Color(0xFF3B82F6), // sad
      Color(0xFFF97316), // stressed
    ];

    const labels = [
      'angry',
      'anxious',
      'happy',
      'joyful',
      'neutral',
      'sad',
      'stressed',
    ];

    const data = [
      [0.4, 0.3, 0.8, 0.4, 0.6, 0.0, 0.6], // CN
      [0.5, 0.3, 0.7, 0.6, 0.3, 0.0, 0.6], // T2
      [0.2, 0.2, 0.7, 0.4, 0.4, 0.0, 0.4], // T3
      [0.2, 0.2, 0.8, 0.5, 0.3, 0.0, 0.4], // T4
      [0.4, 0.3, 0.9, 0.7, 0.7, 0.0, 0.4], // T5
      [0.6, 0.3, 0.8, 0.7, 0.7, 0.0, 0.5], // T6
      [0.3, 0.2, 0.8, 0.6, 0.6, 0.0, 0.5], // T7
    ];

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cảm xúc Theo Ngày (7 ngày qua)',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: CustomPaint(painter: _StackedBarChartPainter(data, colors)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days
                .map(
                  (d) => Text(
                    d,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                )
                .toList(),
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
    final barWidth = size.width / (data.length * 1.8);
    final maxHeight = size.height * 0.9;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final series = data[i];
      double x = (i * barWidth * 1.8) + barWidth * 0.4;

      double accumulated = 0;
      for (int j = 0; j < series.length; j++) {
        final value = series[j];
        if (value <= 0) continue;

        final segmentHeight = value * (maxHeight / 3.2);
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            size.height - accumulated - segmentHeight,
            barWidth,
            segmentHeight,
          ),
          const Radius.circular(3),
        );

        paint.color = colors[j];
        canvas.drawRRect(rect, paint);
        accumulated += segmentHeight;
      }
    }

    final axisPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//
//  CẢM XÚC PHỔ BIẾN NHẤT
//

class _TopEmotionCard extends StatelessWidget {
  const _TopEmotionCard();

  @override
  Widget build(BuildContext context) {
    final items = [
      _EmotionSummary('Vui vẻ', 4, 0.9, const Color(0xFF22C55E)),
      _EmotionSummary('Bình thường', 4, 0.75, const Color(0xFF6B7280)),
      _EmotionSummary('Căng thẳng', 4, 0.7, const Color(0xFFF97316)),
      _EmotionSummary('Giận dữ', 3, 0.6, const Color(0xFFEF4444)),
      _EmotionSummary('Hạnh phúc', 2, 0.45, const Color(0xFFEAB308)),
    ];

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
      border: Border.all(color: Colors.black.withOpacity(0.06), width: 1),
    ),
    child: child,
  );
}

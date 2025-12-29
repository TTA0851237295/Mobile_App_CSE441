import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user/Check_in.dart';
import '../../providers/checkin_provider.dart';

class StressReliefScreen extends StatefulWidget {
  const StressReliefScreen({super.key});

  @override
  State<StressReliefScreen> createState() => _StressReliefScreenState();
}

class _StressReliefScreenState extends State<StressReliefScreen> {
  bool _showNotification = false;

  @override
  Widget build(BuildContext context) {
    final checkInProvider = Provider.of<CheckInProvider>(context);
    final latestAdvice = checkInProvider.latestAdvice ?? 'Hãy thử kỹ thuật hít thở 4-7-8 để giảm căng thẳng nhé!';

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, 0.00),
                      end: Alignment(1.00, 1.00),
                      colors: [
                        Color(0xFFEEF5FE),
                        Color(0xFFFAF5FE),
                        Color(0xFFFCF1F7)
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              height: 278,
                              decoration: ShapeDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment(0.00, 0.00),
                                  end: Alignment(1.00, 1.00),
                                  colors: [
                                    Color(0xFFAC46FF),
                                    Color(0xFFF6329A)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  const Positioned(
                                    left: 24,
                                    top: 24,
                                    child: Text(
                                      'Xin chào! 👋',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Arimo',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    left: 24,
                                    top: 80,
                                    child: SizedBox(
                                      width: 250,
                                      child: Text(
                                        'Hãy dành 5 giây để chia sẻ cảm xúc của bạn lúc này.',
                                        style: TextStyle(
                                          color: Color(0xFFF2E7FE),
                                          fontSize: 16,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    top: 168,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withValues(alpha: 0.20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                      ),
                                      child: const Text(
                                        '3 check-in hôm nay',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 24,
                                    top: 228,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 154,
                                          height: 6,
                                          decoration: ShapeDecoration(
                                            color: Colors.white.withValues(alpha: 0.20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              width: 77,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Bước 1/2',
                                          style: TextStyle(
                                            color: Color(0xFFF2E7FE),
                                            fontSize: 12,
                                            fontFamily: 'Arimo',
                                            fontWeight: FontWeight.w400,
                                            height: 1.33,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Show He2 notification card if check-in was completed
                            if (_showNotification) ...[
                              Container(
                                width: double.infinity,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 0.67,
                                      color: Color(0xFFEDEDED),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.lightbulb_outline,
                                      color: Color(0xFFAC46FF),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Color(0xFF0A0A0A),
                                            fontSize: 14,
                                            fontFamily: 'Arimo',
                                            fontWeight: FontWeight.w400,
                                            height: 1.43,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'Lời nhắc từ Tâm An: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            TextSpan(
                                              text: latestAdvice,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.33,
                                    color: Colors.black.withValues(alpha: 0.10),
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    double availableWidth = constraints.maxWidth;
                                    double itemWidth = (availableWidth - 12) / 2;

                                    return Column(
                                      children: [
                                        const Text(
                                          'Bạn đang cảm thấy thế nào?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF0A0A0A),
                                            fontSize: 16,
                                            fontFamily: 'Arimo',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          alignment: WrapAlignment.start,
                                          children: [
                                            _buildFeelingItem(
                                              context,
                                              width: itemWidth,
                                              iconWidget: const Icon(
                                                  Icons
                                                      .sentiment_very_satisfied_outlined,
                                                  color: Colors.amber,
                                                  size: 32),
                                              label: 'Hạnh phúc',
                                            ),
                                            _buildFeelingItem(
                                              context,
                                              width: itemWidth,
                                              iconWidget: const Icon(
                                                  Icons
                                                      .sentiment_satisfied_alt_outlined,
                                                  color: Colors.green,
                                                  size: 32),
                                              label: 'Vui vẻ',
                                            ),
                                            _buildFeelingItem(
                                              context,
                                              width: itemWidth,
                                              iconWidget: const Icon(
                                                  Icons.sentiment_neutral_outlined,
                                                  color: Colors.grey,
                                                  size: 32),
                                              label: 'Bình thường',
                                            ),
                                            _buildFeelingItem(
                                              context,
                                              width: itemWidth,
                                              iconWidget: const Icon(
                                                  Icons.thunderstorm_outlined,
                                                  color: Colors.blue,
                                                  size: 32),
                                              label: 'Buồn',
                                            ),
                                            _buildFeelingItem(
                                              context,
                                              width: itemWidth,
                                              iconWidget: const Icon(
                                                  Icons
                                                      .sentiment_dissatisfied_outlined,
                                                  color: Colors.purple,
                                                  size: 32),
                                              label: 'Lo lắng',
                                            ),
                                            _buildFeelingItem(
                                              context,
                                              width: itemWidth,
                                              iconWidget: const Icon(
                                                  Icons.bolt_outlined,
                                                  color: Colors.orange,
                                                  size: 32),
                                              label: 'Căng thẳng',
                                            ),
                                            _buildFeelingItem(
                                              context,
                                              width: itemWidth,
                                              iconWidget: Image.asset(
                                                'assets/angry.png',
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  return const Icon(
                                                      Icons.mood_bad_outlined,
                                                      color: Colors.red,
                                                      size: 32);
                                                },
                                              ),
                                              label: 'Giận dữ',
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeelingItem(BuildContext context,
      {required double width,
        required Widget iconWidget,
        required String label}) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckInDetailScreen(selectedEmotion: label),
          ),
        );

        // If result is 'show_notification', update state to show He2 widget
        if (result == 'show_notification' && mounted) {
          setState(() {
            _showNotification = true;
          });
        }
      },
      child: Container(
        width: width,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(height: 8),
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
      ),
    );
  }
}
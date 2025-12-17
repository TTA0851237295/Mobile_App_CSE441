import 'package:flutter/material.dart';
import '../../widgets/create_goal_modal.dart';

class GoalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const GoalsScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _buildBackButton(),
          const SizedBox(height: 24),
          _buildHeader(),
          const SizedBox(height: 24),
          _buildActiveGoalsSection(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        if (widget.onBack != null) {
          widget.onBack!();
        } else {
          Navigator.pop(context);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chevron_left,
            color: Color(0xFF980FFA),
            size: 20,
          ),
          const SizedBox(width: 4),
          const Text(
            'Quay lại',
            style: TextStyle(
              color: Color(0xFF980FFA),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mục tiêu của tôi',
                style: TextStyle(
                  color: Color(0xFF980FFA),
                  fontSize: 20,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Theo dõi và đạt được mục tiêu cải thiện',
                style: TextStyle(
                  color: Color(0xFF495565),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildCreateGoalButton(),
      ],
    );
  }

  Widget _buildCreateGoalButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CreateGoalModal();
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF030213),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            const Text(
              'Tạo mục tiêu',
              style: TextStyle(
                color: Colors.white,
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

  Widget _buildActiveGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mục tiêu đang thực hiện (2)',
          style: TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 18,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        _buildGoalCard1(),
        const SizedBox(height: 16),
        _buildGoalCard2(),
      ],
    );
  }

  Widget _buildGoalCard1() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25.27),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFF2E7FE),
          width: 1.27,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giảm căng thẳng công việc',
                      style: TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 18,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                        height: 1.56,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Suy nghĩ ít về công việc thôi',
                      style: TextStyle(
                        color: Color(0xFF717182),
                        fontSize: 16,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 1.27,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Giảm căng thẳng',
                  style: TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 12,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Progress Section
          Container(
            padding: const EdgeInsets.all(13.26),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFAF5FE), Color(0xFFFCF1F7)],
              ),
              border: Border.all(
                color: const Color(0xFFF2E7FE),
                width: 1.27,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.show_chart,
                          size: 16,
                          color: Color(0xFF59168B),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tiến độ thực tế',
                          style: TextStyle(
                            color: Color(0xFF59168B),
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.remove,
                      size: 16,
                      color: Color(0xFF59168B),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Giảm căng thẳng',
                      style: TextStyle(
                        color: Color(0xFF8200DA),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      '0%',
                      style: TextStyle(
                        color: Color(0xFF59168B),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0x33030213),
                    borderRadius: BorderRadius.circular(42770700),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.0,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF030213),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Hãy check-in thường xuyên hơn để Tâm An có thể theo dõi tiến độ mục tiêu của bạn.',
                    style: TextStyle(
                      color: Color(0xFF8200DA),
                      fontSize: 12,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Time Section
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thời gian',
                    style: TextStyle(
                      color: Color(0xFF495565),
                      fontSize: 14,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    '7 ngày còn lại',
                    style: TextStyle(
                      color: Color(0xFF495565),
                      fontSize: 14,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(42770700),
                ),
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF030213),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Suggestions Section
          Container(
            padding: const EdgeInsets.all(13.26),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(
                color: const Color(0xFFDAEAFE),
                width: 1.27,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Color(0xFF1B388E),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Gợi ý hành động',
                      style: TextStyle(
                        color: Color(0xFF1B388E),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSuggestion('🎯 Hạn chế "Họp" - đang gây 86% cảm xúc tiêu cực'),
                const SizedBox(height: 6),
                _buildSuggestion('💚 Dành nhiều thời gian hơn với "Bạn bè" - giúp bạn vui hơn 100%'),
                const SizedBox(height: 6),
                _buildSuggestion('⏰ Nghỉ ngơi hoặc thư giãn vào khoảng 12h - thời điểm bạn thường căng thẳng nhất'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Button Section
          Row(
            children: [
              Opacity(
                opacity: 0.5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A63E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Hoàn thành',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '(Cần đạt 80% để hoàn thành)',
                style: TextStyle(
                  color: Color(0xFF697282),
                  fontSize: 12,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard2() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25.27),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFF2E7FE),
          width: 1.27,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Đi chơi nhiều với ny',
                      style: TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 18,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                        height: 1.56,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '1 tuần đi chơi với ny 1 lần',
                      style: TextStyle(
                        color: Color(0xFF717182),
                        fontSize: 16,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 1.27,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Tăng hạnh phúc',
                  style: TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 12,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Progress Section
          Container(
            padding: const EdgeInsets.all(13.26),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFAF5FE), Color(0xFFFCF1F7)],
              ),
              border: Border.all(
                color: const Color(0xFFF2E7FE),
                width: 1.27,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.show_chart,
                          size: 16,
                          color: Color(0xFF59168B),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tiến độ thực tế',
                          style: TextStyle(
                            color: Color(0xFF59168B),
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.remove,
                      size: 16,
                      color: Color(0xFF59168B),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tăng hạnh phúc',
                      style: TextStyle(
                        color: Color(0xFF8200DA),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      '0%',
                      style: TextStyle(
                        color: Color(0xFF59168B),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0x33030213),
                    borderRadius: BorderRadius.circular(42770700),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.0,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF030213),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Hãy check-in thường xuyên hơn để Tâm An có thể theo dõi tiến độ mục tiêu của bạn.',
                    style: TextStyle(
                      color: Color(0xFF8200DA),
                      fontSize: 12,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Time Section
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thời gian',
                    style: TextStyle(
                      color: Color(0xFF495565),
                      fontSize: 14,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    '730 ngày còn lại',
                    style: TextStyle(
                      color: Color(0xFF495565),
                      fontSize: 14,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(42770700),
                ),
                child: FractionallySizedBox(
                  widthFactor: 1.0,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF030213),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Suggestions Section
          Container(
            padding: const EdgeInsets.all(13.26),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(
                color: const Color(0xFFDAEAFE),
                width: 1.27,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: Color(0xFF1B388E),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Gợi ý hành động',
                      style: TextStyle(
                        color: Color(0xFF1B388E),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSuggestion('🎯 Hạn chế "Họp" - đang gây 86% cảm xúc tiêu cực'),
                const SizedBox(height: 6),
                _buildSuggestion('💚 Dành nhiều thời gian hơn với "Bạn bè" - giúp bạn vui hơn 100%'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Button Section
          Row(
            children: [
              Opacity(
                opacity: 0.5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A63E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Hoàn thành',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '(Cần đạt 80% để hoàn thành)',
                style: TextStyle(
                  color: Color(0xFF697282),
                  fontSize: 12,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '•',
          style: TextStyle(
            color: Color(0xFF1347E5),
            fontSize: 12,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1347E5),
              fontSize: 12,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
        ),
      ],
    );
  }

}


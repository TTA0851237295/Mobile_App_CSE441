import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/create_goal_modal.dart';
import '../../providers/goal_provider.dart';

class GoalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const GoalsScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GoalProvider>().fetchGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);
    if (goalProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<GoalProvider>().fetchGoals(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildBackButton(),
            const SizedBox(height: 24),
            _buildHeader(),
            const SizedBox(height: 24),
            _buildActiveGoalsSection(goalProvider),
            const SizedBox(height: 24),
            if (goalProvider.completedGoals.isNotEmpty)
              _buildCompletedGoalsSection(goalProvider),
            const SizedBox(height: 80),
          ],
        ),
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

  Widget _buildActiveGoalsSection(GoalProvider goalProvider) {
    final activeGoals = goalProvider.activeGoals;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mục tiêu đang thực hiện (${activeGoals.length})',
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 18,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        if (activeGoals.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFF2E7FE),
                width: 1.27,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF5FF),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.gps_fixed,
                      size: 40,
                      color: Color(0xFF9333EA),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Chưa có mục tiêu',
                  style: TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 18,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đặt mục tiêu để theo dõi và cải\nthiện sức khỏe tinh thần của\nbạn.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF717182),
                    fontSize: 14,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          )
        else
          ...activeGoals.map((goal) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildGoalCard(goal, goalProvider),
          )),
      ],
    );
  }

  Widget _buildCompletedGoalsSection(GoalProvider goalProvider) {
    final completedGoals = goalProvider.completedGoals;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đã hoàn thành (${completedGoals.length})',
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 18,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        ...completedGoals.map((goal) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildGoalCard(goal, goalProvider),
        )),
      ],
    );
  }

  Widget _buildGoalCard(goal, GoalProvider goalProvider) {
    final isCompleted = goal.status == 'COMPLETED';
    final progressPercent = goal.progressPercent;
    final daysRemaining = goal.daysRemaining;
    final isOverdue = goal.isOverdue;

    // Xác định loại badge dựa trên targetType hoặc category
    String badgeText = _getGoalBadgeText(goal);
    Color badgeColor = _getGoalBadgeColor(goal);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          // Header với tiêu đề và badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: TextStyle(
                        color: isCompleted ? const Color(0xFF717182) : const Color(0xFF0A0A0A),
                        fontSize: 18,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: const TextStyle(
                        color: Color(0xFF717182),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Badge loại mục tiêu
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 12,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Progress section
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFAF5FE), Color(0xFFFCF1F7)],
                ),
                border: Border.all(color: const Color(0xFFF2E7FE), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.show_chart, size: 18, color: Color(0xFF59168B)),
                      const SizedBox(width: 8),
                      const Text(
                        'Tiến độ thực tế',
                        style: TextStyle(
                          color: Color(0xFF59168B),
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '—',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor,
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${progressPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Color(0xFF59168B),
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressPercent / 100,
                      minHeight: 8,
                      backgroundColor: const Color(0x33030213),
                      valueColor: AlwaysStoppedAnimation<Color>(badgeColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hãy check-in thường xuyên hơn để Tâm An có thể theo dõi tiến độ mục tiêu của bạn.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Thời gian và ngày còn lại
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Thời gian',
                    style: TextStyle(
                      color: Color(0xFF717182),
                      fontSize: 14,
                      fontFamily: 'Arimo',
                    ),
                  ),
                ],
              ),
              Text(
                isOverdue
                    ? 'Đã quá hạn'
                    : '$daysRemaining ngày còn lại',
                style: TextStyle(
                  color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF717182),
                  fontSize: 14,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Gợi ý hành động
          if (!isCompleted) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFFFF6B00)),
                      SizedBox(width: 8),
                      Text(
                        'Gợi ý hành động',
                        style: TextStyle(
                          color: Color(0xFF0A0A0A),
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildSuggestionItem(
                    '❌',
                    'Hạn chế "Họp" - đang gây 86% cảm xúc tiêu cực',
                    const Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 6),
                  _buildSuggestionItem(
                    '💚',
                    'Dành nhiều thời gian hơn với "Bạn bè" - giúp bạn vui hơn 100%',
                    const Color(0xFF22C55E),
                  ),
                ],
              ),
            ),
          ],

          // Nút hoàn thành
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (!isCompleted)
                GestureDetector(
                  onTap: () async {
                    if (progressPercent >= 80) {
                      await goalProvider.updateGoalStatus(goal.id, 'COMPLETED');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('🎉 Chúc mừng! Đã hoàn thành mục tiêu!')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cần đạt 80% để hoàn thành'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: progressPercent >= 80
                          ? const Color(0xFF22C55E)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: progressPercent >= 80 ? Colors.white : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Hoàn thành',
                          style: TextStyle(
                            color: progressPercent >= 80 ? Colors.white : Colors.grey.shade600,
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 18, color: Color(0xFF22C55E)),
                      SizedBox(width: 6),
                      Text(
                        'Đã hoàn thành',
                        style: TextStyle(
                          color: Color(0xFF22C55E),
                          fontSize: 14,
                          fontFamily: 'Arimo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                '(Cần đạt 80%)',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontFamily: 'Arimo',
                  fontStyle: FontStyle.italic,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Xóa mục tiêu'),
                      content: const Text('Bạn có chắc muốn xóa mục tiêu này?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Xóa'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await goalProvider.deleteGoal(goal.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã xóa mục tiêu')),
                      );
                    }
                  }
                },
                child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String emoji, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  String _getGoalBadgeText(goal) {
    final targetType = goal.targetType ?? goal.category ?? '';
    switch (targetType.toUpperCase()) {
      case 'EMOTION':
        return 'Tăng hạnh phúc';
      case 'ACTIVITY':
        return 'Hoạt động';
      case 'LOCATION':
        return 'Địa điểm';
      case 'COUNT':
      default:
        return 'Check-in';
    }
  }

  Color _getGoalBadgeColor(goal) {
    final targetType = goal.targetType ?? goal.category ?? '';
    switch (targetType.toUpperCase()) {
      case 'EMOTION':
        return const Color(0xFF10B981); // Green
      case 'ACTIVITY':
        return const Color(0xFF3B82F6); // Blue
      case 'LOCATION':
        return const Color(0xFFFF6B00); // Orange
      case 'COUNT':
      default:
        return const Color(0xFF9333EA); // Purple
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Không xác định';
    return '${date.day}/${date.month}/${date.year}';
  }

  // ignore: unused_element
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

  // ignore: unused_element
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


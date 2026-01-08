import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/goal_provider.dart';

class CreateGoalModal extends StatefulWidget {
  const CreateGoalModal({Key? key}) : super(key: key);

  @override
  State<CreateGoalModal> createState() => _CreateGoalModalState();
}

class _CreateGoalModalState extends State<CreateGoalModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(text: '7');
  bool _isLoading = false;

  String _selectedGoalType = 'Giảm căng thẳng';

  final List<String> _goalTypes = [
    'Giảm căng thẳng',
    'Cải thiện tâm trạng',
    'Tăng cường sức khỏe',
    'Phát triển bản thân',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 392.60,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1.27,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
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
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.fromLTRB(25.27, 25.27, 25.27, 25.27),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 16),

                  // Form
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleField(),
                          const SizedBox(height: 16),
                          _buildDescriptionField(),
                          const SizedBox(height: 16),
                          _buildGoalTypeDropdown(),
                          const SizedBox(height: 16),
                          _buildDurationField(),
                          const SizedBox(height: 24),
                          _buildCreateButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Close Button
            Positioned(
              right: 17.27,
              top: 17.27,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            'Tạo mục tiêu mới',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 18,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
              letterSpacing: -0.45,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const SizedBox(
          width: double.infinity,
          child: Text(
            'Đặt mục tiêu cụ thể để cải thiện sức khỏe tinh thần',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF495565),
              fontSize: 14,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.43,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiêu đề mục tiêu',
          style: TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.27,
              color: Colors.black.withValues(alpha: 0),
            ),
          ),
          child: TextField(
            controller: _titleController,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              hintText: 'VD: Giảm căng thẳng công việc',
              hintStyle: TextStyle(
                color: Color(0xFF717182),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mô tả',
          style: TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.27,
              color: Colors.black.withValues(alpha: 0),
            ),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
            decoration: const InputDecoration(
              hintText: 'Mô tả chi tiết mục tiêu của bạn...',
              hintStyle: TextStyle(
                color: Color(0xFF717182),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại mục tiêu',
          style: TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.27,
              color: Colors.black.withValues(alpha: 0),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGoalType,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.black.withValues(alpha: 0.5),
              ),
              style: const TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 14,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
              dropdownColor: const Color(0xFFF3F3F5),
              items: _goalTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedGoalType = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thời gian (ngày)',
          style: TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F3F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.27,
              color: Colors.black.withValues(alpha: 0),
            ),
          ),
          child: TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Color(0xFF0A0A0A),
              fontSize: 16,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _createGoal,
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey : const Color(0xFF030213),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Tạo mục tiêu',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _createGoal() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final days = int.tryParse(_durationController.text) ?? 7;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tiêu đề mục tiêu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final startDate = DateTime.now();
    final endDate = startDate.add(Duration(days: days));

    final success = await context.read<GoalProvider>().createGoal(
      title: title,
      description: description.isNotEmpty ? description : _selectedGoalType,
      startDate: startDate,
      endDate: endDate,
      targetCount: days, // Số ngày = số lần check-in mục tiêu
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      // Refresh lại danh sách goals
      if (context.mounted) {
        await context.read<GoalProvider>().fetchGoals();
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Đã tạo mục tiêu mới!')),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<GoalProvider>().errorMessage ?? 'Có lỗi xảy ra'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CheckInSummary.dart';
import '../../widgets/custom_app_bar.dart';
import '../../providers/checkin_provider.dart';
import '../../config/app_config.dart';
import '../../models/check_in.dart' as models;

class CheckInDetailScreen extends StatefulWidget {
  final String selectedEmotion;

  const CheckInDetailScreen({super.key, required this.selectedEmotion});

  @override
  State<CheckInDetailScreen> createState() => _CheckInDetailScreenState();
}

class _CheckInDetailScreenState extends State<CheckInDetailScreen> {
  bool _isNoteExpanded = false;
  final TextEditingController _noteController = TextEditingController();

  // Selection states
  late String _selectedEmotion;
  String? _selectedLocation;
  String? _selectedActivity;
  String? _selectedCompany;

  @override
  void initState() {
    super.initState();
    _selectedEmotion = widget.selectedEmotion;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkInProvider = Provider.of<CheckInProvider>(context);
    final todayCount = checkInProvider.getTodayCheckInCount();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 24, left: 16, right: 16, bottom: 100),
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gradient Card
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
                                    width: 311,
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
                                        horizontal: 8, vertical: 2),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: Colors.white.withValues(alpha: 0.20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8)),
                                    ),
                                    child: Text(
                                      '$todayCount check-in hôm nay',
                                      style: const TextStyle(
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
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 324.67,
                                        height: 6,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Bước 2/2',
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

                          // Emotion Selection Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFAF5FF),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 0.67,
                                  color: Color(0xFFE9D4FF),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Cảm xúc:',
                                      style: TextStyle(
                                        color: Color(0xFF0A0A0A),
                                        fontSize: 16,
                                        fontFamily: 'Arimo',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFECEEF2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        _selectedEmotion,
                                        style: const TextStyle(
                                          color: Color(0xFF030213),
                                          fontSize: 12,
                                          fontFamily: 'Arimo',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // User can go back to change emotion
                                  },
                                  child: const Text(
                                    'Đổi',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0A0A0A),
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
                          const SizedBox(height: 16),

                          // Location Section
                          _buildLocationSection(),
                          const SizedBox(height: 16),

                          // Activity Section
                          _buildActivitySection(),
                          const SizedBox(height: 16),

                          // Company Section
                          _buildCompanySection(),
                          const SizedBox(height: 16),

                          // Note Section
                          _isNoteExpanded
                              ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.27,
                                  color: Colors.black.withValues(alpha: 0.10),
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: TextField(
                              controller: _noteController,
                              maxLines: 4,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Ghi chú thêm về cảm xúc của bạn (tùy chọn)...',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF717182),
                                  fontSize: 16,
                                  fontFamily: 'Arimo',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF3F3F5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 1.27,
                                    color: Colors.black.withValues(alpha: 0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 1.27,
                                    color: Colors.black.withValues(alpha: 0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 1.27,
                                    color: Colors.black.withValues(alpha: 0.1),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF0A0A0A),
                                fontSize: 16,
                                fontFamily: 'Arimo',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              setState(() {
                                _isNoteExpanded = true;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 36,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.67,
                                    color: Colors.black.withValues(alpha: 0.10),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Thêm ghi chú (tùy chọn)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF0A0A0A),
                                    fontSize: 14,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w400,
                                    height: 1.43,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Complete Button
                          InkWell(
                            onTap: () async {
                              final checkinProvider = Provider.of<CheckinProvider>(context, listen: false);
                              
                              // Map Vietnamese to English enums
                              final locationEnum = AppConfig.locationToEnum[_selectedLocation] ?? 'OTHER';
                              final activityEnum = AppConfig.activityToEnum[_selectedActivity] ?? 'OTHER';
                              final peopleEnum = AppConfig.peopleToEnum[_selectedCompany] ?? 'OTHER';
                              
                              // Gọi API tạo check-in
                              final success = await checkinProvider.createCheckin(
                                emotion: _selectedEmotion,
                                locationTag: locationEnum,
                                activityTag: activityEnum,
                                peopleTag: peopleEnum,
                                note: _noteController.text.isNotEmpty ? _noteController.text : null,
                              );

                              if (!context.mounted) return;

                              if (success) {
                                // Navigate tới summary với data
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckInSummaryScreen(
                                      emotion: _selectedEmotion,
                                      location: _selectedLocation,
                                      activity: _selectedActivity,
                                      company: _selectedCompany,
                                      note: _noteController.text.isNotEmpty
                                          ? _noteController.text
                                          : null,
                                    ),
                                  ),
                                );

                                // Nếu result là true, quay về màn hình chính với thông báo
                                if (result == true && context.mounted) {
                                  Navigator.pop(context, 'show_notification');
                                }
                              } else {
                                // Hiển thị lỗi
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(checkinProvider.errorMessage ?? 'Có lỗi xảy ra'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF030213),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Center(
                                child: Text(
                                  'Hoàn tất Check-in',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Arimo',
                                    fontWeight: FontWeight.w400,
                                    height: 1.56,
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.67,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Bạn đang ở đâu?',
                style: TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '(Tùy chọn)',
                style: TextStyle(
                  color: Color(0xFF697282),
                  fontSize: 14,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSelectableOption('🏢', 'Công ty', _selectedLocation, (value) {
                setState(() => _selectedLocation = _selectedLocation == value ? null : value);
              }),
              _buildSelectableOption('🏠', 'Ở nhà', _selectedLocation, (value) {
                setState(() => _selectedLocation = _selectedLocation == value ? null : value);
              }),
              _buildSelectableOption('🚗', 'Đang di chuyển', _selectedLocation, (value) {
                setState(() => _selectedLocation = _selectedLocation == value ? null : value);
              }),
              _buildSelectableOption('🌳', 'Ngoài trời', _selectedLocation, (value) {
                setState(() => _selectedLocation = _selectedLocation == value ? null : value);
              }),
              _buildSelectableOption('📍', 'Khác', _selectedLocation, (value) {
                setState(() => _selectedLocation = _selectedLocation == value ? null : value);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.67,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Bạn đang làm gì?',
                style: TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '(Tùy chọn)',
                style: TextStyle(
                  color: Color(0xFF697282),
                  fontSize: 14,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSelectableOption('💼', 'Họp', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
              _buildSelectableOption('💻', 'Code', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
              _buildSelectableOption('📚', 'Học bài', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
              _buildSelectableOption('📱', 'Lướt mạng', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
              _buildSelectableOption('🍽️', 'Ăn uống', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
              _buildSelectableOption('🏃', 'Tập thể dục', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
              _buildSelectableOption('🧘', 'Thư giãn', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
              _buildSelectableOption('✨', 'Khác', _selectedActivity, (value) {
                setState(() => _selectedActivity = _selectedActivity == value ? null : value);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.67,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Bạn đang với ai?',
                style: TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '(Tùy chọn)',
                style: TextStyle(
                  color: Color(0xFF697282),
                  fontSize: 14,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSelectableOption('🧑', 'Một mình', _selectedCompany, (value) {
                setState(() => _selectedCompany = _selectedCompany == value ? null : value);
              }),
              _buildSelectableOption('👔', 'Đồng nghiệp', _selectedCompany, (value) {
                setState(() => _selectedCompany = _selectedCompany == value ? null : value);
              }),
              _buildSelectableOption('👨‍💼', 'Sếp', _selectedCompany, (value) {
                setState(() => _selectedCompany = _selectedCompany == value ? null : value);
              }),
              _buildSelectableOption('👨‍👩‍👧‍👦', 'Gia đình', _selectedCompany, (value) {
                setState(() => _selectedCompany = _selectedCompany == value ? null : value);
              }),
              _buildSelectableOption('👯', 'Bạn bè', _selectedCompany, (value) {
                setState(() => _selectedCompany = _selectedCompany == value ? null : value);
              }),
              _buildSelectableOption('💑', 'Người yêu', _selectedCompany, (value) {
                setState(() => _selectedCompany = _selectedCompany == value ? null : value);
              }),
              _buildSelectableOption('👥', 'Khác', _selectedCompany, (value) {
                setState(() => _selectedCompany = _selectedCompany == value ? null : value);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableOption(
      String emoji,
      String label,
      String? selectedValue,
      Function(String) onSelect) {
    final isSelected = selectedValue == label;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect(label),
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.black.withValues(alpha: 0.1),
        highlightColor: Colors.black.withValues(alpha: 0.05),
        child: Container(
          width: 102,
          height: 77,
          decoration: ShapeDecoration(
            color: isSelected ? const Color(0xFFE9D4FF) : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: isSelected ? 1.5 : 0.67,
                color: isSelected
                    ? const Color(0xFF980FFA)
                    : Colors.black.withValues(alpha: 0.10),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 20,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF980FFA) : const Color(0xFF0A0A0A),
                  fontSize: 12,
                  fontFamily: 'Arimo',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
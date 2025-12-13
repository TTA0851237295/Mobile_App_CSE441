import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../widgets/more_menu_item.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.993),
          children: [
            const SizedBox(height: 25.712),
            _buildSectionTitle(),
            const SizedBox(height: 11.99),
            _buildUserCard(),
            const SizedBox(height: 11.99),
            _buildMainMenuItems(context),
            const SizedBox(height: 11.99),
            _buildHelpSection(),
            const SizedBox(height: 35.989),
            _buildVersionInfo(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Khám phá thêm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppConfig.textPrimary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 3.983),
        const Text(
          'Truy cập các tính năng và cài đặt',
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

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.only(
        left: 17.268,
        top: 17.268,
        right: 1.275,
        bottom: 1.275,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x1A000000),
          width: 1.275,
        ),
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 47.979,
            height: 47.979,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(42770700),
            ),
            child: Center(
              child: _buildUserIcon(),
            ),
          ),
          const SizedBox(width: 11.99),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'demo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppConfig.textPrimary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 0),
                const Text(
                  'Người dùng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppConfig.textSecondary,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),

          // Logout Button
          Container(
            width: 35.97,
            height: 35.97,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: _buildLogoutIcon(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            top: 15,
            left: 9,
            child: CustomPaint(
              size: const Size(6, 8),
              painter: _UserIconBottomPainter(),
            ),
          ),
          Positioned(
            top: 3,
            left: 5,
            child: CustomPaint(
              size: const Size(14, 14),
              painter: _UserIconTopPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutIcon() {
    return SizedBox(
      width: 19.996,
      height: 19.996,
      child: Stack(
        children: [
          // Arrow
          Positioned(
            top: 5.833,
            left: 13.333,
            child: CustomPaint(
              size: const Size(5, 8.333),
              painter: _LogoutArrowPainter(),
            ),
          ),
          // Line
          Positioned(
            top: 9.998,
            left: 7.5,
            child: Container(
              width: 10.831,
              height: 1.667,
              decoration: const BoxDecoration(
                color: AppConfig.textSecondary,
              ),
            ),
          ),
          // Door
          Positioned(
            top: 2.5,
            left: 2.5,
            child: CustomPaint(
              size: const Size(5, 15),
              painter: _LogoutDoorPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenuItems(BuildContext context) {
    return Column(
      children: [
        MoreMenuItem(
          icon: _buildGoalsIcon(),
          iconBackgroundColor: const Color(0xFFDBEAFE),
          title: 'Mục tiêu',
          subtitle: 'Đặt và theo dõi mục tiêu sức khỏe',
          onTap: () {
            // TODO: Navigate to Goals screen
          },
        ),
        const SizedBox(height: 11.99),
        MoreMenuItem(
          icon: _buildJournalIcon(),
          iconBackgroundColor: const Color(0xFFDCFCE7),
          title: 'Nhật ký',
          subtitle: 'Ghi chú chi tiết cảm xúc',
          onTap: () {
            Navigator.pushNamed(context, '/journal');
          },
        ),
        const SizedBox(height: 11.99),
        MoreMenuItem(
          icon: _buildSettingsIcon(),
          iconBackgroundColor: const Color(0xFFF3E8FF),
          title: 'Cài đặt',
          subtitle: 'Quản lý tài khoản và ứng dụng',
          onTap: () {
            // TODO: Navigate to Settings screen
          },
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.only(top: 17.268),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0x1A000000),
            width: 1.275,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trợ giúp & Thông tin',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppConfig.textSecondary,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 11.99),
          _buildHelpItem(
            icon: _buildHelpIcon(),
            title: 'Hướng dẫn sử dụng',
            onTap: () {
              // TODO: Navigate to Help screen
            },
          ),
          const SizedBox(height: 7.987),
          _buildHelpItem(
            icon: _buildAboutIcon(),
            title: 'Về Tâm An',
            onTap: () {
              // TODO: Navigate to About screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 43.976,
        padding: const EdgeInsets.only(left: 11.99),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 11.99),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppConfig.textPrimary,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return const Center(
      child: Text(
        'Tâm An v1.0.0',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF6A7282),
          height: 1.43,
        ),
      ),
    );
  }

  Widget _buildGoalsIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            top: 2,
            left: 2,
            child: CustomPaint(
              size: const Size(20, 20),
              painter: _GoalsIconPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: 12,
            child: Container(
              width: 1,
              height: 14,
              color: const Color(0xFF00A63E),
            ),
          ),
          Positioned(
            top: 3,
            left: 2,
            child: CustomPaint(
              size: const Size(20, 18),
              painter: _JournalIconPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        size: const Size(24, 24),
        painter: _SettingsIconPainter(),
      ),
    );
  }

  Widget _buildHelpIcon() {
    return SizedBox(
      width: 19.996,
      height: 19.996,
      child: CustomPaint(
        size: const Size(19.996, 19.996),
        painter: _HelpIconPainter(),
      ),
    );
  }

  Widget _buildAboutIcon() {
    return SizedBox(
      width: 19.996,
      height: 19.996,
      child: CustomPaint(
        size: const Size(19.996, 19.996),
        painter: _AboutIconPainter(),
      ),
    );
  }
}

// Custom Painters for Icons
class _UserIconBottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9810FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.99997
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(7, 10);
    path.lineTo(7, 2);
    path.cubicTo(7, 1.735, 6.895, 1.48, 6.707, 1.293);
    path.cubicTo(6.52, 1.105, 6.265, 1, 6, 1);
    path.lineTo(2, 1);
    path.cubicTo(1.735, 1, 1.48, 1.105, 1.293, 1.293);
    path.cubicTo(1.105, 1.48, 1, 1.735, 1, 2);
    path.lineTo(1, 10);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UserIconTopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9810FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.99997
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.addOval(Rect.fromCircle(center: const Offset(7, 7), radius: 4));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LogoutArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConfig.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.66636
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(0.833, 9.165);
    path.lineTo(5, 5);
    path.lineTo(0.833, 0.833);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LogoutDoorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConfig.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.66636
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(5.832, 15.83);
    path.lineTo(2.5, 15.83);
    path.cubicTo(2.058, 15.83, 1.634, 15.655, 1.321, 15.342);
    path.cubicTo(1.009, 15.03, 0.833, 14.606, 0.833, 14.164);
    path.lineTo(0.833, 2.5);
    path.cubicTo(0.833, 2.058, 1.009, 1.634, 1.321, 1.321);
    path.cubicTo(1.634, 1.009, 2.058, 0.833, 2.5, 0.833);
    path.lineTo(5.832, 0.833);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GoalsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF155DFC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.99997
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Outer circle
    canvas.drawCircle(const Offset(10, 10), 9, paint);

    // Middle circle
    canvas.drawCircle(const Offset(10, 10), 6, paint);

    // Inner circle
    canvas.drawCircle(const Offset(10, 10), 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _JournalIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00A63E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.99997
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(2, 16);
    path.cubicTo(1.735, 16, 1.48, 15.895, 1.293, 15.707);
    path.cubicTo(1.105, 15.52, 1, 15.265, 1, 15);
    path.lineTo(1, 2);
    path.cubicTo(1, 1.735, 1.105, 1.48, 1.293, 1.293);
    path.cubicTo(1.48, 1.105, 1.735, 1, 2, 1);
    path.lineTo(7, 1);
    path.cubicTo(8.061, 1, 9.078, 1.421, 9.828, 2.172);
    path.cubicTo(10.579, 2.922, 11, 3.939, 11, 5);
    path.cubicTo(11, 3.939, 11.421, 2.922, 12.172, 2.172);
    path.cubicTo(12.922, 1.421, 13.939, 1, 15, 1);
    path.lineTo(20, 1);
    path.cubicTo(20.265, 1, 20.52, 1.105, 20.707, 1.293);
    path.cubicTo(20.895, 1.48, 21, 1.735, 21, 2);
    path.lineTo(21, 15);
    path.cubicTo(21, 15.265, 20.895, 15.52, 20.707, 15.707);
    path.cubicTo(20.52, 15.895, 20.265, 16, 20, 16);
    path.lineTo(14, 16);
    path.cubicTo(13.204, 16, 12.441, 16.316, 11.879, 16.879);
    path.cubicTo(11.316, 17.441, 11, 18.204, 11, 19);
    path.cubicTo(11, 18.204, 10.684, 17.441, 10.121, 16.879);
    path.cubicTo(9.559, 16.316, 8.796, 16, 8, 16);
    path.lineTo(2, 16);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SettingsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9810FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.99997
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Outer gear shape
    canvas.drawCircle(const Offset(12, 12), 9, paint);

    // Inner circle
    canvas.drawCircle(const Offset(12, 12), 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HelpIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConfig.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.66636
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Circle
    canvas.drawCircle(const Offset(9.998, 9.998), 8.332, paint);

    // Question mark path
    final path = Path();
    path.moveTo(7.574, 7.499);
    path.cubicTo(7.627, 6.919, 7.896, 6.381, 8.327, 5.989);
    path.cubicTo(8.758, 5.597, 9.319, 5.38, 9.902, 5.38);
    path.cubicTo(10.484, 5.38, 11.045, 5.597, 11.476, 5.989);
    path.cubicTo(11.907, 6.381, 12.176, 6.919, 12.231, 7.499);
    path.cubicTo(12.231, 8.332, 9.932, 9.165, 9.932, 9.165);

    canvas.drawPath(path, paint);

    // Dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(9.998, 14.164), 1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AboutIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppConfig.textSecondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.66636
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Circle
    canvas.drawCircle(const Offset(9.998, 9.998), 8.332, paint);

    // i path
    final path = Path();
    path.moveTo(9.998, 13.331);
    path.lineTo(9.998, 9.998);

    canvas.drawPath(path, paint);

    // Dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(9.998, 6.665), 1, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


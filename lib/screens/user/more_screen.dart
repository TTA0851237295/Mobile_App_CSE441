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
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildSectionTitle(),
            const SizedBox(height: 16),
            _buildUserCard(),
            const SizedBox(height: 16),
            _buildMainMenuItems(context),
            const SizedBox(height: 24),
            _buildHelpSection(),
            const SizedBox(height: 40),
            _buildVersionInfo(),
            const SizedBox(height: 80),
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
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Truy cập các tính năng và cài đặt',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard() {
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
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: _buildUserIcon(),
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'demo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConfig.textPrimary,
                    height: 1.5,
                  ),
                ),
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
            width: 36,
            height: 36,
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
    return const Icon(
      Icons.account_circle,
      size: 24,
      color: Color(0xFF9333EA),
    );
  }

  Widget _buildLogoutIcon() {
    return const Icon(
      Icons.logout,
      size: 20,
      color: AppConfig.textSecondary,
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
        const SizedBox(height: 12),
        MoreMenuItem(
          icon: _buildJournalIcon(),
          iconBackgroundColor: const Color(0xFFDCFCE7),
          title: 'Nhật ký',
          subtitle: 'Ghi chú chi tiết cảm xúc',
          onTap: () {
            Navigator.pushNamed(context, '/journal');
          },
        ),
        const SizedBox(height: 12),
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
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0x1A000000),
            width: 1,
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
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: _buildHelpIcon(),
            title: 'Hướng dẫn sử dụng',
            onTap: () {
              // TODO: Navigate to Help screen
            },
          ),
          const SizedBox(height: 8),
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
        height: 44,
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
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
    return const Icon(
      Icons.gps_fixed,
      size: 24,
      color: Color(0xFF2563EB),
    );
  }

  Widget _buildJournalIcon() {
    return const Icon(
      Icons.menu_book,
      size: 24,
      color: Color(0xFF00A63E),
    );
  }

  Widget _buildSettingsIcon() {
    return const Icon(
      Icons.settings_outlined,
      size: 24,
      color: Color(0xFF9333EA),
    );
  }

  Widget _buildHelpIcon() {
    return const Icon(
      Icons.help_outline,
      size: 20,
      color: AppConfig.textSecondary,
    );
  }

  Widget _buildAboutIcon() {
    return const Icon(
      Icons.info_outline,
      size: 20,
      color: AppConfig.textSecondary,
    );
  }
}

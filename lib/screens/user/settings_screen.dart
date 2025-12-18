import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../widgets/settings_components.dart';
import '../../widgets/change_password_modal.dart';
import '../../widgets/user_guide_modal.dart';
import '../../widgets/privacy_policy_modal.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SettingsScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool enableNotifications = true;
  int reminderFrequency = 3;
  bool enableSound = true;

  final GlobalKey _dropdownKey = GlobalKey();

  static const _iconColor = Color(0xFF9333EA);
  static const _spacing16 = SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _buildHeader(),
          _spacing16,
          _buildPersonalInfoSection(),
          _spacing16,
          _buildAppearanceSection(),
          _spacing16,
          _buildSecuritySection(),
          _spacing16,
          _buildNotificationSection(),
          _spacing16,
          _buildExportDataSection(),
          _spacing16,
          _buildAppInfoSection(),
          _spacing16,
          _buildPrivacySection(),
          _spacing16,
          _buildHelpSection(),
          _spacing16,
          _buildLogoutButton(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _handleLogout() {
    // Clear any saved data if needed
    // Navigate to login screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  void _showReminderFrequencyPicker() {
    final RenderBox? renderBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + renderBox.size.height + 4, // 4px khoảng cách phía dưới
        position.dx + renderBox.size.width,
        position.dy + renderBox.size.height + 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 8,
      color: Colors.white,
      constraints: BoxConstraints(
        minWidth: renderBox.size.width,
        maxWidth: renderBox.size.width,
      ),
      items: [
        _buildMenuItem(1, '1 lần'),
        _buildMenuItem(2, '2 lần'),
        _buildMenuItem(3, '3 lần'),
        _buildMenuItem(4, '4 lần'),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          reminderFrequency = value;
        });
      }
    });
  }

  PopupMenuItem<int> _buildMenuItem(int value, String text) {
    return PopupMenuItem<int>(
      value: value,
      height: 40,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: reminderFrequency == value
                    ? const Color(0xFF9333EA)
                    : const Color(0xFF0A0A0A),
                fontSize: 14,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
            ),
            if (reminderFrequency == value)
              const Icon(
                Icons.check,
                size: 16,
                color: Color(0xFF9333EA),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_back_ios, size: 20, color: AppConfig.primaryColor),
              SizedBox(width: 8),
              Text(
                'Quay lại',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppConfig.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Quản lý tùy chọn cá nhân của bạn',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return SettingsSection(
      icon: Icons.person_outline,
      iconColor: _iconColor,
      title: 'Thông tin cá nhân',
      children: const [
        SizedBox(height: 48),
        SettingsTextField(
          label: 'Tên hiển thị (tùy chọn)',
          hintText: 'Nhập tên của bạn',
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return SettingsSection(
      icon: Icons.nightlight_outlined,
      iconColor: _iconColor,
      title: 'Giao diện',
      children: [
        const SizedBox(height: 48),
        SettingsSwitchRow(
          title: 'Chế độ tối',
          subtitle: 'Giao diện tối giúp giảm mỏi mắt',
          value: isDarkMode,
          onChanged: (value) => setState(() => isDarkMode = value),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return SettingsSection(
      icon: Icons.vpn_key_outlined,
      iconColor: _iconColor,
      title: 'Bảo mật',
      children: [
        const SizedBox(height: 48),
        SettingsButton(
          label: 'Đổi mật khẩu',
          icon: Icons.vpn_key_outlined,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const ChangePasswordModal(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return SettingsSection(
      icon: Icons.notifications_outlined,
      iconColor: _iconColor,
      title: 'Thông báo nhắc nhở',
      children: [
        const SizedBox(height: 48),
        SettingsSwitchRow(
          title: 'Bật thông báo',
          subtitle: 'Nhận nhắc nhở check-in hàng ngày',
          value: enableNotifications,
          onChanged: (value) => setState(() => enableNotifications = value),
        ),
        const SizedBox(height: 16),
        SettingsDropdown(
          label: 'Tần suất nhắc nhở (lần/ngày)',
          value: '$reminderFrequency lần',
          onTap: _showReminderFrequencyPicker,
          dropdownKey: _dropdownKey,
        ),
        const SizedBox(height: 16),
        SettingsSwitchRow(
          title: 'Âm thanh nhắc nhở',
          subtitle: 'Phát âm thanh khi có thông báo',
          value: enableSound,
          onChanged: (value) => setState(() => enableSound = value),
        ),
      ],
    );
  }

  Widget _buildExportDataSection() {
    return SettingsSection(
      icon: Icons.download_outlined,
      iconColor: _iconColor,
      title: 'Xuất dữ liệu',
      children: [
        const SizedBox(height: 24),
        const Text(
          'Tải xuống toàn bộ check-in của bạn để sao lưu hoặc phân tích',
          style: TextStyle(
            color: Color(0xFF495565),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SettingsButton(
                label: 'JSON',
                icon: Icons.download_outlined,
                onTap: () {/* TODO: Export JSON */},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SettingsButton(
                label: 'CSV',
                icon: Icons.download_outlined,
                onTap: () {/* TODO: Export CSV */},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppInfoSection() {
    return SettingsSection(
      icon: Icons.info_outline,
      iconColor: _iconColor,
      title: 'Thông tin ứng dụng',
      children: const [
        SizedBox(height: 24),
        SettingsInfoRow(label: 'Tên ứng dụng', value: 'Tâm An'),
        SizedBox(height: 8),
        SettingsInfoRow(label: 'Phiên bản', value: '1.0.0'),
        SizedBox(height: 8),
        SettingsInfoRow(label: 'Lưu trữ', value: 'LocalStorage'),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return SettingsSection(
      icon: Icons.shield_outlined,
      iconColor: _iconColor,
      title: 'Bảo mật & Quyền riêng tư',
      children: const [
        SizedBox(height: 24),
        SettingsPrivacyItem(
          title: 'Dữ liệu 100% trên thiết bị',
          description: 'Tất cả thông tin được lưu trữ cục bộ, không gửi lên server',
        ),
        SizedBox(height: 12),
        SettingsPrivacyItem(
          title: 'Không thu thập dữ liệu cá nhân',
          description: 'Ứng dụng không yêu cầu hoặc lưu trữ thông tin nhận dạng',
        ),
        SizedBox(height: 12),
        SettingsPrivacyItem(
          title: 'Bạn kiểm soát dữ liệu',
          description: 'Có thể xóa hoặc xuất dữ liệu bất cứ lúc nào',
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return SettingsSection(
      icon: Icons.help_outline,
      iconColor: _iconColor,
      title: 'Trợ giúp',
      children: [
        const SizedBox(height: 24),
        SettingsButton(
          label: 'Hướng dẫn sử dụng',
          icon: Icons.menu_book_outlined,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const UserGuideModal(),
            );
          },
        ),
        const SizedBox(height: 8),
        SettingsButton(
          label: 'Chính sách & Điều khoản',
          icon: Icons.article_outlined,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const PrivacyPolicyModal(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return SettingsButton(
      label: 'Đăng xuất',
      icon: Icons.logout,
      textColor: const Color(0xFFE7000B),
      iconColor: const Color(0xFFE7000B),
      borderColor: const Color(0xFFFFA1A2),
      onTap: _handleLogout,
    );
  }
}


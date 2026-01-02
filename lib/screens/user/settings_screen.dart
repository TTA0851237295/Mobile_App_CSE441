import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../config/app_config.dart';
import '../../widgets/settings_components.dart';
import '../../widgets/change_password_modal.dart';
import '../../widgets/user_guide_modal.dart';
import '../../widgets/privacy_policy_modal.dart';
import '../../providers/theme_provider.dart';
import '../../providers/checkin_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SettingsScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool enableNotifications = true;
  int reminderFrequency = 3;
  bool enableSound = true;
  bool _isLoadingNotificationSettings = true;

  // User info
  String _displayName = '';
  final TextEditingController _displayNameController = TextEditingController();
  final ApiService _apiService = ApiService();
  final NotificationService _notificationService = NotificationService();

  final GlobalKey _dropdownKey = GlobalKey();

  static const _iconColor = Color(0xFF9333EA);
  static const _spacing16 = SizedBox(height: 16);

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadNotificationSettings();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userData = await _apiService.getCurrentUser();
      setState(() {
        _displayName = userData['displayName'] ?? '';
        _displayNameController.text = _displayName;
      });
    } catch (e) {
      // Ignore error
    }
  }

  Future<void> _updateDisplayName() async {
    final newName = _displayNameController.text.trim();
    if (newName.isEmpty || newName == _displayName) return;

    try {
      await _apiService.updateDisplayName(newName);
      setState(() => _displayName = newName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Đã cập nhật tên hiển thị')),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final settings = await _notificationService.getNotificationSettings();
      setState(() {
        enableNotifications = settings['enabled'] as bool;
        reminderFrequency = settings['frequency'] as int;
        enableSound = settings['soundEnabled'] as bool;
        _isLoadingNotificationSettings = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingNotificationSettings = false;
      });
    }
  }

  Future<void> _saveNotificationSettings() async {
    try {
      await _notificationService.saveNotificationSettings(
        enabled: enableNotifications,
        frequency: reminderFrequency,
        soundEnabled: enableSound,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    enableNotifications
                        ? 'Đã bật thông báo nhắc nhở ($reminderFrequency lần/ngày)'
                        : 'Đã tắt thông báo nhắc nhở',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi lưu cài đặt: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _buildHeader(isDarkMode),
          _spacing16,
          _buildPersonalInfoSection(isDarkMode),
          _spacing16,
          _buildAppearanceSection(themeProvider, isDarkMode),
          _spacing16,
          _buildSecuritySection(isDarkMode),
          _spacing16,
          _buildNotificationSection(isDarkMode),
          _spacing16,
          _buildExportDataSection(isDarkMode),
          _spacing16,
          _buildAppInfoSection(isDarkMode),
          _spacing16,
          _buildPrivacySection(isDarkMode),
          _spacing16,
          _buildHelpSection(isDarkMode),
          _spacing16,
          _buildLogoutButton(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void _handleLogout() async {
    // Clear all user data
    context.read<GoalProvider>().clearGoals();
    context.read<CheckinProvider>().clearCheckins();
    context.read<AuthProvider>().logout();

    // Navigate to login screen
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  Future<void> _exportJSON() async {
    try {
      final checkins = context.read<CheckinProvider>().checkins;
      final jsonData = checkins.map((c) => {
        'id': c.id,
        'emotion': c.emotion,
        'location': c.location,
        'activity': c.activity,
        'people': c.people,
        'note': c.note,
        'timestamp': c.timestamp.toIso8601String(),
      }).toList();

      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      // Copy vào clipboard
      await Clipboard.setData(ClipboardData(text: jsonString));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Đã copy ${checkins.length} check-ins (JSON) vào clipboard')),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xuất file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportCSV() async {
    try {
      final checkins = context.read<CheckinProvider>().checkins;

      final buffer = StringBuffer();
      buffer.writeln('ID,Emotion,Location,Activity,People,Note,Timestamp');

      for (var c in checkins) {
        buffer.writeln('"${c.id}","${c.emotion}","${c.location ?? ''}","${c.activity ?? ''}","${c.people ?? ''}","${c.note?.replaceAll('"', '""') ?? ''}","${c.timestamp.toIso8601String()}"');
      }

      // Copy vào clipboard
      await Clipboard.setData(ClipboardData(text: buffer.toString()));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Đã copy ${checkins.length} check-ins (CSV) vào clipboard')),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xuất file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        _saveNotificationSettings();
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

  Widget _buildHeader(bool isDarkMode) {
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
            children: [
              Icon(Icons.arrow_back_ios, size: 20, color: AppConfig.primaryColor),
              const SizedBox(width: 8),
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
        Text(
          'Cài đặt',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Quản lý tùy chọn cá nhân của bạn',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Display Name (editable)
          Text(
            'Tên hiển thị (tùy chọn)',
            style: TextStyle(
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF0A0A0A),
              fontSize: 14,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF2D2D3D) : const Color(0xFFF3F3F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _displayNameController,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (_) => _updateDisplayName(),
              style: TextStyle(
                color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập tên của bạn',
                hintStyle: TextStyle(
                  color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF717182),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(ThemeProvider themeProvider, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.nightlight_outlined, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Giao diện',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chế độ tối',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                        fontSize: 16,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Giao diện tối giúp giảm mỏi mắt',
                      style: TextStyle(
                        color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF495565),
                        fontSize: 14,
                        fontFamily: 'Arimo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Switch(
                value: isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
                activeTrackColor: const Color(0xFF030213),
                thumbColor: WidgetStateProperty.all(Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.vpn_key_outlined, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Bảo mật',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
      ),
    );
  }

  Widget _buildNotificationSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Thông báo nhắc nhở',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSwitchRow('Bật thông báo', 'Nhận nhắc nhở check-in hàng ngày', enableNotifications, (v) {
            setState(() => enableNotifications = v);
            _saveNotificationSettings();
          }, isDarkMode),
          const SizedBox(height: 16),
          SettingsDropdown(
            label: 'Tần suất nhắc nhở (lần/ngày)',
            value: '$reminderFrequency lần',
            onTap: enableNotifications ? _showReminderFrequencyPicker : null,
            dropdownKey: _dropdownKey,
          ),
          const SizedBox(height: 16),
          _buildSwitchRow('Âm thanh nhắc nhở', 'Phát âm thanh khi có thông báo', enableSound, (v) {
            setState(() => enableSound = v);
            _saveNotificationSettings();
          }, isDarkMode),
          if (enableNotifications) ...[
            const SizedBox(height: 16),
            _buildNotificationTimesInfo(isDarkMode),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationTimesInfo(bool isDarkMode) {
    final times = _notificationService.getDefaultTimesForFrequency(reminderFrequency);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2D2D3D) : const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: _iconColor),
              const SizedBox(width: 8),
              Text(
                'Thời gian nhắc nhở:',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 14,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: times.map((time) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _iconColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: _iconColor,
                    fontSize: 13,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A), fontSize: 16, fontFamily: 'Arimo', fontWeight: FontWeight.w400)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF495565), fontSize: 14, fontFamily: 'Arimo', fontWeight: FontWeight.w400)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(value: value, onChanged: onChanged, activeTrackColor: const Color(0xFF030213), thumbColor: WidgetStateProperty.all(Colors.white)),
      ],
    );
  }

  Widget _buildExportDataSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.download_outlined, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Xuất dữ liệu',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Tải xuống toàn bộ check-in của bạn để sao lưu hoặc phân tích',
            style: TextStyle(
              color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF495565),
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
                  onTap: _exportJSON,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SettingsButton(
                  label: 'CSV',
                  icon: Icons.download_outlined,
                  onTap: _exportCSV,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Thông tin ứng dụng',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Tên ứng dụng', 'Tâm An', isDarkMode),
          const SizedBox(height: 8),
          _buildInfoRow('Phiên bản', '1.0.0', isDarkMode),
          const SizedBox(height: 8),
          _buildInfoRow('Lưu trữ', 'Cloud + LocalStorage', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF495565), fontSize: 14, fontFamily: 'Arimo', fontWeight: FontWeight.w400)),
        Text(value, style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A), fontSize: 14, fontFamily: 'Arimo', fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildPrivacySection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Bảo mật & Quyền riêng tư',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildPrivacyItem('Dữ liệu được mã hóa', 'Tất cả thông tin được mã hóa an toàn trên server', isDarkMode),
          const SizedBox(height: 12),
          _buildPrivacyItem('Không thu thập dữ liệu cá nhân', 'Ứng dụng không yêu cầu hoặc lưu trữ thông tin nhận dạng', isDarkMode),
          const SizedBox(height: 12),
          _buildPrivacyItem('Bạn kiểm soát dữ liệu', 'Có thể xóa hoặc xuất dữ liệu bất cứ lúc nào', isDarkMode),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(String title, String description, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, size: 16, color: Color(0xFF00A63E)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A), fontSize: 16, fontFamily: 'Arimo', fontWeight: FontWeight.w400)),
              const SizedBox(height: 4),
              Text(description, style: TextStyle(color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF495565), fontSize: 16, fontFamily: 'Arimo', fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : Colors.black.withValues(alpha: 0.10),
          width: 1.27,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, size: 20, color: _iconColor),
              const SizedBox(width: 12),
              Text(
                'Trợ giúp',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
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
      ),
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


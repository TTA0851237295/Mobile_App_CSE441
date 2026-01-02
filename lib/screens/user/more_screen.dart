import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../widgets/more_menu_item.dart';
import '../../widgets/checkin_reminder_dialog.dart';
import '../../widgets/app_shell.dart';
import '../../providers/theme_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/checkin_provider.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';

class MoreScreen extends StatefulWidget {
  final VoidCallback? onNavigateToJournal;
  final VoidCallback? onNavigateToGoals;
  final VoidCallback? onNavigateToSettings;

  const MoreScreen({
    Key? key,
    this.onNavigateToJournal,
    this.onNavigateToGoals,
    this.onNavigateToSettings,
  }) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  String _username = '';
  String _displayName = '';
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userData = await _apiService.getCurrentUser();
      if (mounted) {
        setState(() {
          _username = userData['username'] ?? '';
          _displayName = userData['displayName'] ?? userData['username'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLogout() {
    // Clear all user data
    context.read<GoalProvider>().clearGoals();
    context.read<CheckinProvider>().clearCheckins();
    context.read<AuthProvider>().logout();

    // Navigate to login screen and clear navigation stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121218) : AppConfig.backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            _buildSectionTitle(isDarkMode),
            const SizedBox(height: 16),
            _buildUserCard(isDarkMode),
            const SizedBox(height: 16),
            _buildMainMenuItems(context, isDarkMode),
            const SizedBox(height: 24),
            _buildHelpSection(isDarkMode),
            const SizedBox(height: 40),
            _buildVersionInfo(isDarkMode),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khám phá thêm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : AppConfig.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Truy cập các tính năng và cài đặt',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? const Color(0xFF2D2D3D) : const Color(0x1A000000),
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
                Text(
                  _isLoading ? 'Đang tải...' : (_displayName.isNotEmpty ? _displayName : _username),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : AppConfig.textPrimary,
                    height: 1.5,
                  ),
                ),
                Text(
                  'Người dùng',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
                    height: 1.43,
                  ),
                ),
              ],
            ),
          ),

          // Logout Button
          InkWell(
            onTap: _handleLogout,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.logout,
                  size: 20,
                  color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
                ),
              ),
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


  Widget _buildMainMenuItems(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        MoreMenuItem(
          icon: _buildGoalsIcon(),
          iconBackgroundColor: const Color(0xFFDBEAFE),
          title: 'Mục tiêu',
          subtitle: 'Đặt và theo dõi mục tiêu sức khỏe',
          isDarkMode: isDarkMode,
          onTap: () {
            widget.onNavigateToGoals?.call();
          },
        ),
        const SizedBox(height: 12),
        MoreMenuItem(
          icon: _buildJournalIcon(),
          iconBackgroundColor: const Color(0xFFDCFCE7),
          title: 'Nhật ký',
          subtitle: 'Ghi chú chi tiết cảm xúc',
          isDarkMode: isDarkMode,
          onTap: () {
            widget.onNavigateToJournal?.call();
          },
        ),
        const SizedBox(height: 12),
        MoreMenuItem(
          icon: _buildSettingsIcon(),
          iconBackgroundColor: const Color(0xFFF3E8FF),
          title: 'Cài đặt',
          subtitle: 'Quản lý tài khoản và ứng dụng',
          isDarkMode: isDarkMode,
          onTap: () {
            widget.onNavigateToSettings?.call();
          },
        ),
      ],
    );
  }

  Widget _buildHelpSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDarkMode ? const Color(0xFF2D2D3D) : const Color(0x1A000000),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Demo & Test',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: _buildNotificationIcon(),
            title: 'Test Thông báo',
            subtitle: 'Xem thông báo check-in ngẫu nhiên',
            isDarkMode: isDarkMode,
            onTap: () {
              _showTestNotification(context);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Trợ giúp & Thông tin',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: _buildHelpIcon(),
            title: 'Hướng dẫn sử dụng',
            isDarkMode: isDarkMode,
            onTap: () {
              // TODO: Navigate to Help screen
            },
          ),
          const SizedBox(height: 8),
          _buildHelpItem(
            icon: _buildAboutIcon(),
            title: 'Về Tâm An',
            isDarkMode: isDarkMode,
            onTap: () {
              // TODO: Navigate to About screen
            },
          ),
        ],
      ),
    );
  }

  void _showTestNotification(BuildContext context) {
    final messages = [
      'Bạn đang cảm thấy thế nào? 🌟',
      'Dành một phút để ghi lại cảm xúc của bạn 💭',
      'Check-in nhanh nhé? 🎯',
      'Hãy theo dõi sức khỏe tinh thần của bạn 🧘',
      'Một ngày của bạn đang diễn ra như thế nào? 🌈',
    ];
    final randomMessage = messages[DateTime.now().millisecond % messages.length];

    // Hiển thị dialog check-in ở trên cùng
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: CheckInReminderDialog(
                  message: randomMessage,
                  useDialogWrapper: false,
                  onCheckIn: () {
                    Navigator.of(context).pop();
                    // Chuyển đến tab Check-in (tab 0 - StressReliefScreen)
                    appShellKey.currentState?.goToCheckInTab();
                  },
                  onDismiss: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
    );

    // Gửi notification test
    final notificationService = NotificationService();

    notificationService.showNotification(
      id: DateTime.now().millisecond,
      title: 'Tâm An',
      body: randomMessage,
      payload: 'checkin_reminder',
    );
  }

  Widget _buildHelpItem({
    required Widget icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDarkMode = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: subtitle != null ? 56 : 44,
        padding: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode ? Colors.white : AppConfig.textPrimary,
                      height: 1.43,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: isDarkMode ? const Color(0xFF9CA3AF) : AppConfig.textSecondary,
                        height: 1.33,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo(bool isDarkMode) {
    return Center(
      child: Text(
        'Tâm An v1.0.0',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF6A7282),
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

  Widget _buildNotificationIcon() {
    return const Icon(
      Icons.notifications_active_outlined,
      size: 20,
      color: Color(0xFF9333EA),
    );
  }
}

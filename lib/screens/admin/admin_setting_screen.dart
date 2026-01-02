import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/change_password_modal.dart';
import '../../services/api_service.dart';
import '../../providers/theme_provider.dart';
import '../auth/auths_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AdminSettingsScreen({super.key, required this.onBack});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final ApiService _apiService = ApiService();

  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;
  bool _isDarkMode = false;
  bool _isTogglingTheme = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userInfo = await _apiService.getCurrentUser();
      setState(() {
        _userInfo = userInfo;
        _isDarkMode = userInfo['themeMode'] == 'DARK';
        _isLoading = false;
      });
      // Đồng bộ theme từ server với ThemeProvider
      if (mounted) {
        context.read<ThemeProvider>().setThemeFromServer(userInfo['themeMode'] ?? 'LIGHT');
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleTheme(bool value) async {
    setState(() => _isTogglingTheme = true);

    try {
      final themeMode = value ? 'DARK' : 'LIGHT';
      await _apiService.updateThemeMode(themeMode);
      setState(() => _isDarkMode = value);

      // Cập nhật ThemeProvider để áp dụng dark mode vào giao diện
      if (mounted) {
        context.read<ThemeProvider>().toggleTheme(value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã chuyển sang chế độ ${value ? 'tối' : 'sáng'}'),
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
    } finally {
      if (mounted) setState(() => _isTogglingTheme = false);
    }
  }

  Future<void> _logout() async {
    await _apiService.clearToken();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121218) : const Color(0xFFF8F3FF),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF8A2BE2)))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Quay lại
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF8A2BE2),
                    ),
                    onPressed: widget.onBack,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Quay lại",
                    style: TextStyle(fontSize: 16, color: Color(0xFF8A2BE2)),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                "Cài đặt Admin",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),

              const SizedBox(height: 4),
              Text(
                "Quản lý cài đặt tài khoản quản trị viên",
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF666666),
                ),
              ),

              const SizedBox(height: 20),

              // ===================== SECTION 1: THÔNG TIN ADMIN =====================
              _sectionCard(
                icon: Icons.verified_user_outlined,
                title: "Thông tin Admin",
                isDarkMode: isDarkMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tài khoản", style: _getLabelStyle(isDarkMode)),
                    const SizedBox(height: 4),
                    Text(_userInfo?['username'] ?? 'admin', style: _getValueStyle(isDarkMode)),
                    const SizedBox(height: 12),
                    Text("Vai trò", style: _getLabelStyle(isDarkMode)),
                    const SizedBox(height: 4),
                    Text(
                      _userInfo?['role'] == 'ADMIN' ? 'Quản trị viên' : 'Người dùng',
                      style: _getValueStyle(isDarkMode),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===================== SECTION 2: GIAO DIỆN =====================
              _sectionCard(
                icon: Icons.dark_mode_outlined,
                title: "Giao diện",
                isDarkMode: isDarkMode,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Chế độ tối", style: _getLabelStyle(isDarkMode)),
                        const SizedBox(height: 3),
                        Text(
                          "Giao diện tối giúp giảm mỏi mắt",
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode ? const Color(0xFF6B7280) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    _isTogglingTheme
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Switch(
                            value: _isDarkMode,
                            onChanged: _toggleTheme,
                            activeTrackColor: const Color(0xFF8A2BE2).withValues(alpha: 0.5),
                            thumbColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return const Color(0xFF8A2BE2);
                              }
                              return null;
                            }),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===================== SECTION 3: BẢO MẬT =====================
              _sectionCard(
                icon: Icons.lock_outline,
                title: "Bảo mật",
                isDarkMode: isDarkMode,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ChangePasswordModal(),
                      );
                    },
                    icon: Icon(
                      Icons.key,
                      color: isDarkMode ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
                    ),
                    label: Text(
                      "Đổi mật khẩu",
                      style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? const Color(0xFF2E2E3E) : Colors.white,
                      side: BorderSide(color: isDarkMode ? const Color(0xFF3E3E4E) : Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===================== SECTION 4: THÔNG TIN ỨNG DỤNG =====================
              _sectionCard(
                icon: Icons.info_outline,
                title: "Thông tin ứng dụng",
                isDarkMode: isDarkMode,
                child: Column(
                  children: [
                    _InfoRow(label: "Tên ứng dụng", value: "Tâm An", isDarkMode: isDarkMode),
                    _InfoRow(label: "Phiên bản", value: "1.0.0", isDarkMode: isDarkMode),
                    _InfoRow(label: "Lưu trữ", value: "Cloud Server", isDarkMode: isDarkMode),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===================== ĐĂNG XUẤT =====================
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Đăng xuất",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? const Color(0xFF3D1A1A) : const Color(0xFFFFEFEF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper functions for dark mode styles
TextStyle _getLabelStyle(bool isDarkMode) {
  return TextStyle(
    fontSize: 14,
    color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey,
  );
}

TextStyle _getValueStyle(bool isDarkMode) {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: isDarkMode ? Colors.white : Colors.black,
  );
}

// =====================================================================
//   COMPONENTS
// =====================================================================

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool isDarkMode;
  const _InfoRow({required this.label, required this.value, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _getLabelStyle(isDarkMode)),
          Text(value, style: _getValueStyle(isDarkMode)),
        ],
      ),
    );
  }
}

class _sectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final bool isDarkMode;

  const _sectionCard({
    required this.icon,
    required this.title,
    required this.child,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.purple.shade50),
        boxShadow: isDarkMode ? null : [
          BoxShadow(
            color: Colors.purple.shade50,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF8A2BE2)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}


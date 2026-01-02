import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auths_screen.dart';
import '../../services/api_service.dart';
import '../../providers/theme_provider.dart';

class AdminSettingsBody extends StatefulWidget {
  final VoidCallback onOpenSettings; // mở trang setting chi tiết

  const AdminSettingsBody({super.key, required this.onOpenSettings});

  @override
  State<AdminSettingsBody> createState() => _AdminSettingsBodyState();
}

class _AdminSettingsBodyState extends State<AdminSettingsBody> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _userInfo;
  bool _isLoading = true;

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
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      color: isDarkMode ? const Color(0xFF121218) : const Color(0xFFF8F3FF),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(isDarkMode: isDarkMode),
            const SizedBox(height: 16),

            // ⭐ CARD ĐĂNG XUẤT
            _ProfileCard(
              userInfo: _userInfo,
              isLoading: _isLoading,
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 16),

            // ⭐ CARD CÀI ĐẶT – mở Setting chi tiết
            _SettingsCard(onTap: widget.onOpenSettings, isDarkMode: isDarkMode),

            const SizedBox(height: 24),

            _FooterVersion(isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }
}

//
// ───────────────────────────────────────── HEADER ─────────────────────────────────────────
//

class _Header extends StatelessWidget {
  final bool isDarkMode;
  const _Header({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khám phá thêm',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : const Color(0xFF0A0A0A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Quản lý cài đặt admin',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF495565),
          ),
        ),
      ],
    );
  }
}

//
// ──────────────────────────────── CARD ĐĂNG XUẤT ────────────────────────────────
//

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic>? userInfo;
  final bool isLoading;
  final bool isDarkMode;

  const _ProfileCard({this.userInfo, this.isLoading = false, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final username = userInfo?['username'] ?? 'admin';
    final role = userInfo?['role'] == 'ADMIN' ? 'Quản trị viên' : 'Người dùng';

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        _showLogoutDialog(context, isDarkMode);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFF2E7FE),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.person, color: Color(0xFF8B5CF6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF495565),
                          ),
                        ),
                      ],
                    ),
            ),
            Icon(Icons.logout, color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

//
// ────────────────────────────────────── LOGOUT DIALOG ─────────────────────────────────────
//

void _showLogoutDialog(BuildContext context, bool isDarkMode) {
  final ApiService apiService = ApiService();

  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Xác nhận đăng xuất",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Bạn có chắc muốn đăng xuất? Dữ liệu của bạn vẫn được lưu trữ an toàn trên server.",
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    await apiService.clearToken();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? const Color(0xFF8B5CF6) : Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Đăng xuất"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

//
// ─────────────────────────────── CARD CÀI ĐẶT ───────────────────────────────
//

class _SettingsCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDarkMode;
  const _SettingsCard({required this.onTap, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap, // ⭐ chuyển sang tab Setting chi tiết
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFF2E7FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.settings, color: Color(0xFF8B5CF6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cài đặt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tùy chỉnh tài khoản admin',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF495565),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

//
// ───────────────────────────────────── FOOTER ─────────────────────────────────────
//

class _FooterVersion extends StatelessWidget {
  final bool isDarkMode;
  const _FooterVersion({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tâm An v1.0.0',
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF697282),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'change_password_modal.dart';

class AdminSettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const AdminSettingsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // 🔙 Quay lại
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF8A2BE2)),
                    onPressed: onBack,   // <<< QUAN TRỌNG
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Quay lại",
                    style: TextStyle(fontSize: 16, color: Color(0xFF8A2BE2)),
                  ),
                ],
              ),


              const SizedBox(height: 12),

              const Text(
                "Cài đặt Admin",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A0A0A),
                ),
              ),

              const SizedBox(height: 4),
              const Text(
                "Quản lý cài đặt tài khoản quản trị viên",
                style: TextStyle(fontSize: 15, color: Color(0xFF666666)),
              ),

              const SizedBox(height: 20),

              // ===================== SECTION 1: THÔNG TIN ADMIN =====================
              _sectionCard(
                icon: Icons.verified_user_outlined,
                title: "Thông tin Admin",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Tài khoản", style: _labelStyle),
                    SizedBox(height: 4),
                    Text("admin", style: _valueStyle),
                    SizedBox(height: 12),
                    Text("Vai trò", style: _labelStyle),
                    SizedBox(height: 4),
                    Text("Quản trị viên", style: _valueStyle),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===================== SECTION 2: GIAO DIỆN =====================
              _sectionCard(
                icon: Icons.dark_mode_outlined,
                title: "Giao diện",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Chế độ tối", style: _labelStyle),
                        SizedBox(height: 3),
                        Text(
                          "Giao diện tối giúp giảm mỏi mắt",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        )
                      ],
                    ),
                    Switch(value: false, onChanged: (_) {})
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===================== SECTION 3: BẢO MẬT =====================
              _sectionCard(
                icon: Icons.lock_outline,
                title: "Bảo mật",
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ChangePasswordModal(),
                      );
                    },
                    icon: const Icon(Icons.key, color: Color(0xFF8A2BE2)),
                    label: const Text(
                      "Đổi mật khẩu",
                      style: TextStyle(color: Color(0xFF0A0A0A)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.shade300),
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
                child: Column(
                  children: const [
                    _InfoRow(label: "Tên ứng dụng", value: "Tâm An"),
                    _InfoRow(label: "Phiên bản", value: "1.0.0"),
                    _InfoRow(label: "Lưu trữ", value: "LocalStorage"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===================== ĐĂNG XUẤT =====================
              Center(
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Đăng xuất",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEFEF),
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

// =====================================================================
//   COMPONENTS
// =====================================================================

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _labelStyle),
          Text(value, style: _valueStyle),
        ],
      ),
    );
  }
}

class _sectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _sectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.purple.shade50),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade50,
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A0A0A),
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

const _labelStyle = TextStyle(fontSize: 14, color: Colors.grey);
const _valueStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

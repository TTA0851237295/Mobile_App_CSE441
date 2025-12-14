import 'package:flutter/material.dart';
import 'package:mobileapp_taman/widgets/layout/app_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _index = 0; // 0 = Login, 1 = Register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF4F7FF), Color(0xFFFFF1F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ===== HEADER (KHÔNG BAO GIỜ NHẢY) =====
                const _Header(),

                const SizedBox(height: 28),

                // ===== TAB LOGIN / REGISTER =====
                _AuthSwitch(
                  index: _index,
                  onChanged: (i) {
                    setState(() {
                      _index = i;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // ===== BODY =====
                IndexedStack(
                  index: _index,
                  children: const [_LoginForm(), _RegisterForm()],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// ================= HEADER =================
//

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFAC46FF), Color(0xFFF6329A)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 30,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite_border,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Tâm An',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF980FFA),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Trợ lý Nhận diện Căng thẳng',
          style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

//
// ================= TAB SWITCH =================
//

class _AuthSwitch extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _AuthSwitch({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFECECF0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _TabItem(
            text: 'Đăng nhập',
            active: index == 0,
            onTap: () => onChanged(0),
          ),
          _TabItem(
            text: 'Đăng ký',
            active: index == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _TabItem({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: active ? null : onTap,
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
// ================= LOGIN FORM =================
//

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Label(text: 'Tên đăng nhập'),
        const SizedBox(height: 8),
        const _InputField(),

        const SizedBox(height: 20),

        const _Label(text: 'Mật khẩu'),
        const SizedBox(height: 8),
        const _InputField(obscure: true),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF030213),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AppShell()),
              );
            },

            child: const Text(
              'Đăng nhập',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // DEMO CARD
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE9D8FD)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '🎯 Tài khoản demo:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF495565),
                  ),
                ),
                SizedBox(height: 8),
                Text('👤 Admin: admin / admin123', textAlign: TextAlign.center),
                SizedBox(height: 4),
                Text('👤 User: demo / demo123', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//
// ================= REGISTER FORM =================
//

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          const _Label(text: 'Tên đăng nhập'),
          const SizedBox(height: 8),
          const _InputField(),

          const SizedBox(height: 20),

          const _Label(text: 'Mật khẩu'),
          const SizedBox(height: 8),
          const _InputField(obscure: true),

          const SizedBox(height: 20),

          const _Label(text: 'Xác nhận mật khẩu'),
          const SizedBox(height: 8),
          const _InputField(obscure: true),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF030213),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // TODO: xử lý register
              },
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ✅ PHẦN DƯỚI CÙNG (CARD “Dữ liệu lưu trên thiết bị”)
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE9D8FD)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFFF3E8FF),
                    child: Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dữ liệu của bạn được lưu 100% trên thiết bị này',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF495565),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
// ================= SHARED COMPONENTS =================
//

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0A0A0A),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final bool obscure;
  const _InputField({this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3F3F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

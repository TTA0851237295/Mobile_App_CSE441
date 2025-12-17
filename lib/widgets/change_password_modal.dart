import 'package:flutter/material.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({Key? key}) : super(key: key);

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 392.60,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.27,
              color: Colors.black.withValues(alpha: 0.10),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 4),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(0, 10),
              spreadRadius: -3,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25.27, 25.27, 25.27, 25.27),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Đổi mật khẩu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0A0A0A),
                            fontSize: 18,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w700,
                            height: 1,
                            letterSpacing: -0.45,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.99),
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Nhập mật khẩu cũ và mật khẩu mới',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF495565),
                            fontSize: 14,
                            fontFamily: 'Arimo',
                            fontWeight: FontWeight.w400,
                            height: 1.43,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 31.99),

                  // Form fields
                  _buildPasswordField(
                    label: 'Mật khẩu cũ',
                    obscureText: _obscureOldPassword,
                    onToggleVisibility: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                  ),
                  const SizedBox(height: 15.99),

                  _buildPasswordField(
                    label: 'Mật khẩu mới',
                    hint: 'Tối thiểu 6 ký tự',
                    obscureText: _obscureNewPassword,
                    onToggleVisibility: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                  ),
                  const SizedBox(height: 15.99),

                  _buildPasswordField(
                    label: 'Xác nhận mật khẩu mới',
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  const SizedBox(height: 15.99),

                  // Submit button
                  Container(
                    width: double.infinity,
                    height: 35.99,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF030213),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // TODO: Handle password change
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: const Center(
                          child: Text(
                            'Đổi mật khẩu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Arimo',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Close button
            Positioned(
              right: 17.27,
              top: 17.27,
              child: Opacity(
                opacity: 0.70,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 15.99,
                    height: 15.99,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 15.99,
                      color: Color(0xFF0A0A0A),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    String? hint,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF0A0A0A),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),
        const SizedBox(height: 7.99),
        Container(
          height: 35.99,
          decoration: ShapeDecoration(
            color: const Color(0xFFF3F3F5),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.27,
                color: Colors.black.withValues(alpha: 0),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  obscureText: obscureText,
                  style: const TextStyle(
                    color: Color(0xFF0A0A0A),
                    fontSize: 16,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFF717182),
                      fontSize: 16,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: onToggleVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 15.99,
                    color: const Color(0xFF717182),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


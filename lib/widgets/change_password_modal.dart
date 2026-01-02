import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChangePasswordModal extends StatefulWidget {
  const ChangePasswordModal({Key? key}) : super(key: key);

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorMessage;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty) {
      return 'Vui lòng nhập mật khẩu cũ';
    }
    if (newPassword.isEmpty) {
      return 'Vui lòng nhập mật khẩu mới';
    }
    if (newPassword.length < 6) {
      return 'Mật khẩu mới phải có ít nhất 6 ký tự';
    }
    if (confirmPassword.isEmpty) {
      return 'Vui lòng xác nhận mật khẩu mới';
    }
    if (newPassword != confirmPassword) {
      return 'Mật khẩu xác nhận không khớp';
    }
    if (oldPassword == newPassword) {
      return 'Mật khẩu mới phải khác mật khẩu cũ';
    }
    return null;
  }

  Future<void> _changePassword() async {
    final validationError = _validatePassword();
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _apiService.changePasswordV2(
        currentPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Đổi mật khẩu thành công!')),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

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

                  // Error message
                  if (_errorMessage != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.99),
                  ],

                  // Form fields
                  _buildPasswordField(
                    label: 'Mật khẩu cũ',
                    controller: _oldPasswordController,
                    obscureText: _obscureOldPassword,
                    onToggleVisibility: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                  ),
                  const SizedBox(height: 15.99),

                  _buildPasswordField(
                    label: 'Mật khẩu mới',
                    hint: 'Tối thiểu 6 ký tự',
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    onToggleVisibility: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                  ),
                  const SizedBox(height: 15.99),

                  _buildPasswordField(
                    label: 'Xác nhận mật khẩu mới',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  const SizedBox(height: 15.99),

                  // Submit button
                  Container(
                    width: double.infinity,
                    height: 35.99,
                    decoration: ShapeDecoration(
                      color: _isLoading ? Colors.grey : const Color(0xFF030213),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoading ? null : _changePassword,
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
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
    required TextEditingController controller,
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
          height: 42,
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
          child: Center(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              textAlignVertical: TextAlignVertical.center,
              expands: false,
              maxLines: 1,
              style: const TextStyle(
                color: Color(0xFF0A0A0A),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
                height: 1.0,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF717182),
                  fontSize: 16,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: InkWell(
                  onTap: onToggleVisibility,
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                    color: const Color(0xFF717182),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


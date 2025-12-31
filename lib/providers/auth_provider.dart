import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _loadToken();
  }

  // Load token khi khởi động app
  Future<void> _loadToken() async {
    await _apiService.loadToken();
    // Nếu có token, lấy thông tin user
    if (_apiService.hasToken) {
      try {
        await getProfile();
      } catch (e) {
        // Token hết hạn hoặc không hợp lệ
        await _apiService.clearToken();
      }
    }
  }

  // Đăng nhập
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.login(username, password);
      
      // Parse user data từ AuthResponse
      // Backend trả về: { token, userId, username, role, expiresIn }
      _currentUser = User.fromJson(response);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Đăng ký
  Future<bool> register({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.register(
        username: username,
        password: password,
        fullName: fullName,
        email: email,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Lấy thông tin profile
  Future<void> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      _currentUser = User.fromJson(response);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  // Đổi mật khẩu
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _apiService.clearToken();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

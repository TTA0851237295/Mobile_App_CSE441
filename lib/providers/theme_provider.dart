import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final ApiService _apiService = ApiService();

  bool get isDarkMode => _isDarkMode;
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  
  ThemeProvider() {
    _loadThemeFromPrefs();
  }
  
  // Load theme từ SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
  
  // Toggle theme và lưu vào SharedPreferences + API
  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    notifyListeners();

    // Đồng bộ với API
    try {
      await _apiService.updateThemeMode(value ? 'DARK' : 'LIGHT');
    } catch (e) {
      // Ignore API error, theme vẫn được lưu local
      print('Error syncing theme to server: $e');
    }
  }
  
  // Set theme từ server khi đăng nhập
  Future<void> setThemeFromServer(String themeMode) async {
    _isDarkMode = themeMode == 'DARK';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}


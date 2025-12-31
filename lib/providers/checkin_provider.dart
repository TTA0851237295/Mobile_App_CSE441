import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/check_in.dart';
import '../config/app_config.dart';

class CheckinProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<CheckIn> _checkins = [];
  Map<String, dynamic>? _emotionStats;
  bool _isLoading = false;
  String? _errorMessage;

  List<CheckIn> get checkins => _checkins;
  Map<String, dynamic>? get emotionStats => _emotionStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Tạo check-in mới
  Future<bool> createCheckin({
    required String emotion,
    required String locationTag,
    required String activityTag,
    required String peopleTag,
    String? note,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Map Vietnamese emotion to English enum
      final emotionEnum = AppConfig.emotionToEnum[emotion] ?? 'NEUTRAL';
      
      final response = await _apiService.createCheckin(
        emotion: emotionEnum,
        locationTag: locationTag,
        activityTag: activityTag,
        peopleTag: peopleTag,
        note: note,
      );
      
      // Thêm check-in mới vào đầu list
      _checkins.insert(0, CheckIn.fromJson(response));
      
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

  // Lấy danh sách check-ins
  Future<void> fetchCheckins() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getCheckins();
      _checkins = response.map((json) => CheckIn.fromJson(json)).toList();
      
      print('DEBUG CHECKIN PROVIDER: Fetched ${_checkins.length} check-ins');
      for (var checkin in _checkins.take(5)) {
        print('  - ${checkin.timestamp}: ${checkin.emotion}');
      }
      if (_checkins.length > 5) {
        print('  ... and ${_checkins.length - 5} more');
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy thống kê cảm xúc
  Future<void> fetchEmotionStats(int days) async {
    try {
      _emotionStats = await _apiService.getEmotionStats(days);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

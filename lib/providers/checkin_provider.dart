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
  String? _latestAdvice;

  // Pagination
  int _currentPage = 0;
  int _totalPages = 1;
  bool _hasMore = true;

  List<CheckIn> get checkins => _checkins;
  Map<String, dynamic>? get emotionStats => _emotionStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get latestAdvice => _latestAdvice;
  bool get hasMore => _hasMore;

  // Get today's check-ins
  List<CheckIn> getTodayCheckIns() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    print('DEBUG getTodayCheckIns: Total check-ins: ${_checkins.length}');
    print('DEBUG getTodayCheckIns: Today start: $today');
    print('DEBUG getTodayCheckIns: Tomorrow start: $tomorrow');

    final todayCheckins = _checkins.where((checkin) {
      // So sánh timestamp với ngày hôm nay (từ 00:00 đến 23:59:59)
      final isToday = checkin.timestamp.isAfter(today.subtract(const Duration(seconds: 1))) &&
                      checkin.timestamp.isBefore(tomorrow);
      print('DEBUG getTodayCheckIns: Checkin at ${checkin.timestamp} - isToday: $isToday');
      return isToday;
    }).toList();

    print('DEBUG getTodayCheckIns: Found ${todayCheckins.length} check-ins today');
    return todayCheckins;
  }

  // Get today's check-in count
  int getTodayCheckInCount() {
    return getTodayCheckIns().length;
  }

  // Set latest advice
  void setLatestAdvice(String advice) {
    _latestAdvice = advice;
    notifyListeners();
  }

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
    _currentPage = 0;
    notifyListeners();

    try {
      final response = await _apiService.getCheckins();
      _checkins = response.map((json) => CheckIn.fromJson(json)).toList();
      
      print('DEBUG CHECKIN PROVIDER: Current local time: ${DateTime.now()}');
      print('DEBUG CHECKIN PROVIDER: Fetched ${_checkins.length} check-ins');
      for (var checkin in _checkins.take(5)) {
        print('  - Timestamp: ${checkin.timestamp} (isUtc: ${checkin.timestamp.isUtc}) - Emotion: ${checkin.emotion}');
      }
      if (_checkins.length > 5) {
        print('  ... and ${_checkins.length - 5} more');
      }
      
      // Debug today count
      final todayCount = getTodayCheckInCount();
      print('DEBUG CHECKIN PROVIDER: Today check-ins count: $todayCount');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('DEBUG CHECKIN PROVIDER ERROR: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Lấy thêm check-ins (infinite scroll)
  Future<void> fetchMoreCheckins() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCheckinsPaginated(page: _currentPage + 1, size: 20);
      final content = response['content'] as List? ?? [];

      if (content.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage++;
        _checkins.addAll(content.map((json) => CheckIn.fromJson(json)).toList());
        _totalPages = response['totalPages'] ?? 1;
        _hasMore = _currentPage < _totalPages - 1;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Xóa check-in
  Future<bool> deleteCheckin(dynamic checkinId) async {
    try {
      await _apiService.deleteCheckin(checkinId);
      _checkins.removeWhere((c) => c.id == checkinId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
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

  // Clear tất cả checkins khi logout
  void clearCheckins() {
    _checkins = [];
    _emotionStats = null;
    _isLoading = false;
    _errorMessage = null;
    _latestAdvice = null;
    _currentPage = 0;
    _totalPages = 1;
    _hasMore = true;
    notifyListeners();
  }
}

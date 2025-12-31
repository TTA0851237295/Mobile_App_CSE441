import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalCheckins {
    if (_stats == null) return 0;
    final value = _stats!['totalCheckIns'];
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
  
  int get currentStreak {
    if (_stats == null) return 0;
    final value = _stats!['streak'];
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
  
  int get activeGoals {
    if (_stats == null) return 0;
    final value = _stats!['activeGoals'];
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
  
  Map<String, int> get emotionCounts {
    if (_stats == null || _stats!['emotionDistribution'] == null) return {};
    try {
      final distribution = _stats!['emotionDistribution'] as Map<String, dynamic>;
      return distribution.map((key, value) {
        int count = 0;
        if (value is int) {
          count = value;
        } else if (value is double) {
          count = value.toInt();
        } else if (value != null) {
          count = int.tryParse(value.toString()) ?? 0;
        }
        return MapEntry(key, count);
      });
    } catch (e) {
      return {};
    }
  }

  List<dynamic> get emotionTrends {
    if (_stats == null || _stats!['emotionTrends'] == null) return [];
    try {
      return _stats!['emotionTrends'] as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  // Lấy thống kê dashboard
  Future<void> fetchStats({int? days}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stats = await _apiService.getDashboardStats(days: days);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

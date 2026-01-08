import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Goal {
  final int id;
  final String title;
  final String description;
  final String? category;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? targetDate;
  final String? targetType;
  final dynamic targetValue;
  final int? targetCount;
  final int? progressValue;
  final DateTime createdAt;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.status,
    this.startDate,
    this.endDate,
    this.targetDate,
    this.targetType,
    this.targetValue,
    this.targetCount,
    this.progressValue,
    required this.createdAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'],
      status: json['status'] ?? 'ACTIVE',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate']) : null,
      targetType: json['targetType'],
      targetValue: json['targetValue'],
      targetCount: json['targetCount'],
      progressValue: json['progressValue'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  // Tính tiến độ phần trăm
  double get progressPercent {
    if (targetCount != null && targetCount! > 0) {
      return ((progressValue ?? 0) / targetCount! * 100).clamp(0, 100);
    }
    return 0;
  }

  // Kiểm tra deadline
  bool get isOverdue {
    final deadline = endDate ?? targetDate;
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline) && status != 'COMPLETED';
  }

  // Số ngày còn lại
  int get daysRemaining {
    final deadline = endDate ?? targetDate;
    if (deadline == null) return 0;
    return deadline.difference(DateTime.now()).inDays;
  }
}

class GoalProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Goal> _goals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Goal> get goals => _goals;
  List<Goal> get activeGoals => _goals.where((g) => g.status == 'ACTIVE').toList();
  List<Goal> get completedGoals => _goals.where((g) => g.status == 'COMPLETED').toList();
  List<Goal> get cancelledGoals => _goals.where((g) => g.status == 'CANCELLED').toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Lấy danh sách goals
  Future<void> fetchGoals() async {
    _isLoading = true;
    _errorMessage = null;
    _goals = []; // Clear goals cũ trước khi fetch mới
    notifyListeners();

    try {
      final response = await _apiService.getGoalsPaginated(page: 0, size: 100);
      print('DEBUG GOAL PROVIDER: Response type: ${response.runtimeType}');
      print('DEBUG GOAL PROVIDER: Response: $response');

      final content = response['content'] as List? ?? response as List? ?? [];
      print('DEBUG GOAL PROVIDER: Content count: ${content.length}');

      _goals = content.map((json) => Goal.fromJson(json)).toList();
      print('DEBUG GOAL PROVIDER: Parsed goals count: ${_goals.length}');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('DEBUG GOAL PROVIDER: Error: $e');
      // Fallback to old API if paginated fails
      try {
        final response = await _apiService.getGoals();
        _goals = response.map((json) => Goal.fromJson(json)).toList();
      } catch (_) {
        _goals = [];
      }
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tạo goal mới theo API documentation mới
  Future<bool> createGoal({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    String targetType = 'COUNT',
    dynamic targetValue,
    int? targetCount,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createGoal(
        title: title,
        description: description,
        category: targetType,
        startDate: startDate.toIso8601String().split('T')[0],
        targetDate: endDate.toIso8601String().split('T')[0],
        targetType: targetType,
        targetCount: targetCount ?? 30,
      );
      
      _goals.insert(0, Goal.fromJson(response));

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

  // Cập nhật trạng thái goal
  Future<bool> updateGoalStatus(int id, String status) async {
    try {
      await _apiService.updateGoal(id, {'status': status});

      // Cập nhật local
      final index = _goals.indexWhere((g) => g.id == id);
      if (index != -1) {
        final goal = _goals[index];
        _goals[index] = Goal(
          id: goal.id,
          title: goal.title,
          description: goal.description,
          category: goal.category,
          status: status,
          startDate: goal.startDate,
          endDate: goal.endDate,
          targetDate: goal.targetDate,
          targetType: goal.targetType,
          targetValue: goal.targetValue,
          targetCount: goal.targetCount,
          progressValue: goal.progressValue,
          createdAt: goal.createdAt,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Xóa goal
  Future<bool> deleteGoal(int id) async {
    try {
      await _apiService.deleteGoal(id);
      _goals.removeWhere((g) => g.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear tất cả goals khi logout
  void clearGoals() {
    _goals = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}

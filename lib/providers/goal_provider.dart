import 'package:flutter/material.dart';
import '../services/api_service.dart';

class Goal {
  final int id;
  final String title;
  final String description;
  final String category;
  final String status;
  final DateTime targetDate;
  final DateTime createdAt;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.targetDate,
    required this.createdAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      status: json['status'],
      targetDate: DateTime.parse(json['targetDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class GoalProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Goal> _goals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Goal> get goals => _goals;
  List<Goal> get activeGoals => _goals.where((g) => g.status != 'COMPLETED').toList();
  List<Goal> get completedGoals => _goals.where((g) => g.status == 'COMPLETED').toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Lấy danh sách goals
  Future<void> fetchGoals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getGoals();
      _goals = response.map((json) => Goal.fromJson(json)).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Tạo goal mới
  Future<bool> createGoal({
    required String title,
    required String description,
    required String category,
    required DateTime targetDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.createGoal(
        title: title,
        description: description,
        category: category,
        targetDate: targetDate.toIso8601String(),
      );
      
      _goals.add(Goal.fromJson(response));
      
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
      await _apiService.updateGoalStatus(id, status);
      
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
          targetDate: goal.targetDate,
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
}

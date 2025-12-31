import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  // Getter để check token
  bool get hasToken => _token != null;

  // Lấy token từ SharedPreferences
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // Lưu token vào SharedPreferences
  Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Xóa token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Headers mặc định
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // ==================== AUTH APIs ====================
  
  // Đăng nhập
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/auth/login');
    final response = await http.post(
      url,
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data']; // Backend trả về trong 'data' field
      if (data != null && data['token'] != null) {
        await saveToken(data['token']);
      }
      return data;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Đăng nhập thất bại');
    }
  }

  // Đăng ký
  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String fullName,
    required String email,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/auth/register');
    final response = await http.post(
      url,
      headers: _getHeaders(includeAuth: false),
      body: jsonEncode({
        'username': username,
        'password': password,
        'fullName': fullName,
        'email': email,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['data']; // Backend trả về trong 'data' field
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Đăng ký thất bại');
    }
  }

  // ==================== USER APIs ====================
  
  // Lấy thông tin profile
  Future<Map<String, dynamic>> getProfile() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/users/profile');
    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data']; // Backend trả về trong 'data' field
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Lấy thông tin thất bại');
    }
  }

  // Đổi mật khẩu
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/users/change-password');
    final response = await http.put(
      url,
      headers: _getHeaders(),
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Đổi mật khẩu thất bại: ${response.body}');
    }
  }

  // Lấy dashboard stats
  Future<Map<String, dynamic>> getDashboardStats({int? days}) async {
    String url = '${AppConfig.apiBaseUrl}/users/dashboard';
    if (days != null) {
      url += '?days=$days';
    }
    final response = await http.get(Uri.parse(url), headers: _getHeaders());

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? {};
    } else {
      throw Exception('Lấy thống kê thất bại: ${response.body}');
    }
  }

  // ==================== CHECK-IN APIs ====================
  
  // Tạo check-in
  Future<Map<String, dynamic>> createCheckin({
    required String emotion,
    required String locationTag,
    required String activityTag,
    required String peopleTag,
    String? note,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/checkins');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({
        'emotion': emotion,
        'locationTag': locationTag,
        'activityTag': activityTag,
        'peopleTag': peopleTag,
        'note': note,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Tạo check-in thất bại: ${response.body}');
    }
  }

  // Lấy danh sách check-in
  Future<List<dynamic>> getCheckins() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/checkins');
    final response = await http.get(url, headers: _getHeaders());

    print('DEBUG API: GET /checkins - Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data'] ?? responseData; // Support both formats
      print('DEBUG API: Checkins count: ${data.length}');
      return data is List ? data : [];
    } else {
      throw Exception('Lấy danh sách check-in thất bại: ${response.body}');
    }
  }

  // Lấy emotion stats
  Future<Map<String, dynamic>> getEmotionStats(int days) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/checkins/stats?days=$days');
    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Lấy thống kê cảm xúc thất bại: ${response.body}');
    }
  }

  // ==================== GOAL APIs ====================
  
  // Lấy danh sách goals
  Future<List<dynamic>> getGoals() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/goals');
    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Lấy danh sách mục tiêu thất bại: ${response.body}');
    }
  }

  // Tạo goal mới
  Future<Map<String, dynamic>> createGoal({
    required String title,
    required String description,
    required String category,
    required String targetDate,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/goals');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'category': category,
        'targetDate': targetDate,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Tạo mục tiêu thất bại: ${response.body}');
    }
  }

  // Cập nhật trạng thái goal
  Future<Map<String, dynamic>> updateGoalStatus(int id, String status) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/goals/$id/status');
    final response = await http.patch(
      url,
      headers: _getHeaders(),
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Cập nhật trạng thái thất bại: ${response.body}');
    }
  }

  // Xóa goal
  Future<void> deleteGoal(int id) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/goals/$id');
    final response = await http.delete(url, headers: _getHeaders());

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Xóa mục tiêu thất bại: ${response.body}');
    }
  }

  // ==================== TIPS APIs ====================
  
  // Lấy danh sách tips (không cần auth)
  Future<List<dynamic>> getTips() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/tips');
    final response = await http.get(
      url,
      headers: _getHeaders(includeAuth: false),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Lấy danh sách tips thất bại: ${response.body}');
    }
  }

  // ==================== ADMIN APIs ====================
  
  // Lấy danh sách users (Admin only)
  Future<List<dynamic>> getAllUsers() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/admin/users');
    final response = await http.get(url, headers: _getHeaders());

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Lấy danh sách người dùng thất bại: ${response.body}');
    }
  }

  // Tạo tip (Admin only)
  Future<Map<String, dynamic>> createTip({
    required String title,
    required String content,
    required String category,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/admin/tips');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Tạo tip thất bại: ${response.body}');
    }
  }
}

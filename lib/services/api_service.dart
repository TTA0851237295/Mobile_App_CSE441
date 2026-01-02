import 'dart:convert';
import 'dart:async';
import 'dart:io';
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

    // Debug: In ra URL đang dùng
    print('DEBUG LOGIN: Calling API at: $url');

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(includeAuth: false),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      print('DEBUG LOGIN: Response status: ${response.statusCode}');
      print('DEBUG LOGIN: Response body: ${response.body}');

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
    } on TimeoutException {
      print('DEBUG LOGIN: TimeoutException - Server không phản hồi trong 15s');
      throw Exception('Kết nối quá lâu. Vui lòng kiểm tra mạng hoặc server.');
    } on SocketException catch (e) {
      print('DEBUG LOGIN: SocketException - $e');
      throw Exception('Không thể kết nối đến server. Vui lòng kiểm tra mạng.');
    } catch (e) {
      print('DEBUG LOGIN: Other error - $e');
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Đăng ký
  // Đăng ký
  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/auth/register');

    try {
      final response = await http.post(
        url,
        headers: _getHeaders(includeAuth: false),
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['data']; // Backend trả về trong 'data' field
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Đăng ký thất bại');
      }
    } on TimeoutException {
      throw Exception('Kết nối quá lâu. Vui lòng kiểm tra mạng hoặc server.');
    } on SocketException {
      throw Exception('Không thể kết nối đến server. Vui lòng kiểm tra mạng.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // ==================== USER APIs ====================
  
  // Lấy thông tin profile
  Future<Map<String, dynamic>> getProfile() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/users/profile');

    try {
      final response = await http.get(url, headers: _getHeaders())
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data']; // Backend trả về trong 'data' field
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Lấy thông tin thất bại');
      }
    } on TimeoutException {
      throw Exception('Kết nối quá lâu. Vui lòng kiểm tra mạng hoặc server.');
    } on SocketException {
      throw Exception('Không thể kết nối đến server. Vui lòng kiểm tra mạng.');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Lỗi kết nối: $e');
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
    final body = {
      'emotion': emotion,
      'locationTag': locationTag,
      'activityTag': activityTag,
      'peopleTag': peopleTag,
      'note': note,
    };

    print('DEBUG CREATE CHECKIN: Request body: $body');

    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(body),
    );

    print('DEBUG CREATE CHECKIN: Response status: ${response.statusCode}');
    print('DEBUG CREATE CHECKIN: Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      // Backend trả về trong 'data' field
      return responseData['data'] ?? responseData;
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
    print('DEBUG GOALS API (old): Calling $url');

    final response = await http.get(url, headers: _getHeaders());
    print('DEBUG GOALS API (old): Status: ${response.statusCode}');
    print('DEBUG GOALS API (old): Response: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Backend trả về trong data.content hoặc data hoặc trực tiếp
      final data = responseData['data'];
      if (data is Map && data['content'] != null) {
        return data['content'] as List;
      } else if (data is List) {
        return data;
      } else if (responseData is List) {
        return responseData;
      }
      return [];
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
    String? startDate,
    String targetType = 'COUNT',
    int targetCount = 30,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/goals');

    final body = {
      'title': title,
      'description': description,
      'startDate': startDate ?? DateTime.now().toIso8601String().split('T')[0],
      'endDate': targetDate,
      'targetType': targetType,
      'targetValue': null,
      'targetCount': targetCount,
    };

    print('DEBUG CREATE GOAL: Request body: $body');

    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 15));

    print('DEBUG CREATE GOAL: Response status: ${response.statusCode}');
    print('DEBUG CREATE GOAL: Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      // Backend có thể trả về trong 'data' field hoặc trực tiếp
      return responseData['data'] ?? responseData;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Tạo mục tiêu thất bại');
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
  
  // Lấy thống kê hệ thống (Admin only)
  Future<Map<String, dynamic>> getAdminStats() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/admin/stats');
    final response = await http.get(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    print('DEBUG ADMIN STATS: Response status: ${response.statusCode}');
    print('DEBUG ADMIN STATS: Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data'] ?? responseData;
      print('DEBUG ADMIN STATS: Parsed data: $data');
      return data;
    } else {
      throw Exception('Lấy thống kê hệ thống thất bại: ${response.body}');
    }
  }

  // Lấy danh sách users (Admin only)
  Future<List<dynamic>> getAllUsers() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/admin/users');
    final response = await http.get(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Lấy danh sách người dùng thất bại: ${response.body}');
    }
  }

  // Bật/Tắt trạng thái user (Admin only)
  Future<Map<String, dynamic>> toggleUserStatus(dynamic userId) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/admin/users/$userId/toggle');
    final response = await http.patch(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Cập nhật trạng thái user thất bại: ${response.body}');
    }
  }

  // ==================== TIPS APIs (Admin) ====================

  // Lấy tất cả tips (kể cả inactive - Admin only)
  Future<List<dynamic>> getAllTipsAdmin() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/tips/all');
    final response = await http.get(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Lấy danh sách tips thất bại: ${response.body}');
    }
  }

  // Tạo tip mới (Admin only)
  Future<Map<String, dynamic>> createTip({
    required String title,
    required String content,
    required String category,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/tips');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Tạo tip thất bại: ${response.body}');
    }
  }

  // Xóa tip (Admin only)
  Future<void> deleteTip(dynamic tipId) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/tips/$tipId');
    final response = await http.delete(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Xóa tip thất bại: ${response.body}');
    }
  }

  // Bật/Tắt hiển thị tip (Admin only)
  Future<Map<String, dynamic>> toggleTipStatus(dynamic tipId) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/tips/$tipId/toggle');
    final response = await http.patch(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Cập nhật trạng thái tip thất bại: ${response.body}');
    }
  }

  // ==================== USER SETTINGS APIs ====================

  // Đổi theme mode
  Future<Map<String, dynamic>> updateThemeMode(String themeMode) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/users/theme');
    final response = await http.put(
      url,
      headers: _getHeaders(),
      body: jsonEncode({'themeMode': themeMode}),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Cập nhật theme thất bại: ${response.body}');
    }
  }

  // Đổi mật khẩu (cập nhật để match API doc)
  Future<Map<String, dynamic>> changePasswordV2({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/users/change-password');
    final response = await http.post(
      url,
      headers: _getHeaders(),
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Đổi mật khẩu thất bại');
    }
  }

  // Lấy thông tin user hiện tại
  Future<Map<String, dynamic>> getCurrentUser() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/users/me');
    final response = await http.get(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Lấy thông tin user thất bại: ${response.body}');
    }
  }

  // Đổi tên hiển thị
  Future<Map<String, dynamic>> updateDisplayName(String displayName) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/users/display-name');
    final response = await http.put(
      url,
      headers: _getHeaders(),
      body: jsonEncode({'displayName': displayName}),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Cập nhật tên hiển thị thất bại: ${response.body}');
    }
  }

  // Xóa checkin
  Future<void> deleteCheckin(dynamic checkinId) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/checkins/$checkinId');
    final response = await http.delete(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Xóa check-in thất bại: ${response.body}');
    }
  }

  // Lấy danh sách checkins với phân trang
  Future<Map<String, dynamic>> getCheckinsPaginated({int page = 0, int size = 20}) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/checkins?page=$page&size=$size');
    final response = await http.get(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Lấy danh sách check-in thất bại: ${response.body}');
    }
  }

  // Lấy danh sách goals với phân trang
  Future<Map<String, dynamic>> getGoalsPaginated({int page = 0, int size = 20}) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/goals?page=$page&size=$size');
    print('DEBUG GOALS API: Calling $url');
    print('DEBUG GOALS API: Token: ${_token != null ? "present" : "missing"}');

    final response = await http.get(url, headers: _getHeaders())
        .timeout(const Duration(seconds: 15));

    print('DEBUG GOALS API: Status: ${response.statusCode}');
    print('DEBUG GOALS API: Response: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Lấy danh sách goals thất bại: ${response.body}');
    }
  }

  // Cập nhật goal
  Future<Map<String, dynamic>> updateGoal(dynamic goalId, Map<String, dynamic> data) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}/goals/$goalId');
    final response = await http.patch(
      url,
      headers: _getHeaders(),
      body: jsonEncode(data),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data'] ?? responseData;
    } else {
      throw Exception('Cập nhật goal thất bại: ${response.body}');
    }
  }
}

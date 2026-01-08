import 'package:flutter/material.dart';

class AppConfig {
  // ============ CẤU HÌNH IP SERVER ============
  //
  // Backend đã được deploy lên server public
  // IP này hoạt động trên mọi thiết bị (web, máy thật, máy ảo)
  // =============================================

  static const String _serverIP = '47.129.206.228';  // IP Server public
  static const String _serverPort = '8080';

  static String get apiBaseUrl {
    // Sử dụng cùng một IP server cho tất cả nền tảng
    return 'http://$_serverIP:$_serverPort/api';
  }


  // Emotions
  static const List<String> emotions = [
    'Vui vẻ',
    'Bình thường',
    'Buồn',
    'Căng thẳng',
    'Giận dữ',
  ];

  // Emotion mapping to backend enum
  static const Map<String, String> emotionToEnum = {
    'Hạnh phúc': 'HAPPY',
    'Vui vẻ': 'JOY',
    'Bình thường': 'NEUTRAL',
    'Buồn': 'SAD',
    'Căng thẳng': 'STRESSED',
    'Giận dữ': 'ANGRY',
    'Lo lắng': 'WORRIED',
  };

  // Reverse mapping from enum to Vietnamese
  static const Map<String, String> enumToEmotion = {
    'HAPPY': 'Hạnh phúc',
    'JOY': 'Vui vẻ',
    'NEUTRAL': 'Bình thường',
    'SAD': 'Buồn',
    'STRESSED': 'Căng thẳng',
    'ANGRY': 'Giận dữ',
    'WORRIED': 'Lo lắng',
  };

  // Location mapping to backend enum
  static const Map<String, String> locationToEnum = {
    'Công ty': 'WORK',
    'Ở nhà': 'HOME',
    'Đang di chuyển': 'COMMUTE',
    'Ngoài trời': 'OUTDOOR',
    'Khác': 'OTHER',
  };

  // Activity mapping to backend enum
  static const Map<String, String> activityToEnum = {
    'Họp': 'MEETING',
    'Code': 'CODING',
    'Học bài': 'STUDY',
    'Lướt mạng': 'SOCIAL_MEDIA',
    'Ăn uống': 'EATING',
    'Tập thể dục': 'WORKOUT',
    'Thư giãn': 'RELAX',
    'Khác': 'OTHER',
  };

  // People mapping to backend enum
  static const Map<String, String> peopleToEnum = {
    'Một mình': 'ALONE',
    'Đồng nghiệp': 'COWORKERS',
    'Sếp': 'BOSS',
    'Gia đình': 'FAMILY',
    'Bạn bè': 'FRIENDS',
    'Người yêu': 'PARTNER',
    'Khác': 'OTHER',
  };

  // Colors
  static const Color primaryColor = Color(0xFF9810FA);
  static const Color backgroundColor = Color(0xFFF5F3FF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF030213);
  static const Color textSecondary = Color(0xFF4A5565);
  static const Color borderColor = Color(0x1A000000);

  // Emotion Colors
  static const Map<String, Color> emotionColors = {
    'Vui vẻ': Color(0xFF10B981),
    'Bình thường': Color(0xFF6366F1),
    'Buồn': Color(0xFF3B82F6),
    'Căng thẳng': Color(0xFFFF6900),
    'Giận dữ': Color(0xFFFB2C36),
  };

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 14.0;
  static const double borderRadiusLarge = 20.0;
}

import 'package:flutter/material.dart';
import '../config/app_config.dart';

class CheckIn {
  final String id;
  final String userId;
  final String emotion;
  final DateTime timestamp;
  final String? note;
  final List<String>? tags;
  final String? location;
  final String? activity;
  final String? people;

  CheckIn({
    required this.id,
    required this.userId,
    required this.emotion,
    required this.timestamp,
    this.note,
    this.tags,
    this.location,
    this.activity,
    this.people,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    // Convert emotion enum from backend to Vietnamese
    String emotionValue = json['emotion'] ?? '';
    final vietnameseEmotion = AppConfig.enumToEmotion[emotionValue] ?? emotionValue;
    
    // Convert location/activity/people tags from backend enum to Vietnamese
    String? locationTag = json['locationTag'] ?? json['location'];
    String? activityTag = json['activityTag'] ?? json['activity'];
    String? peopleTag = json['peopleTag'] ?? json['people'];

    // Map enum to Vietnamese
    final locationMap = {
      'HOME': 'Ở nhà',
      'WORK': 'Công ty',
      'COMMUTE': 'Đang di chuyển',
      'OUTDOOR': 'Ngoài trời',
      'OTHER': 'Khác',
    };

    final activityMap = {
      'MEETING': 'Họp',
      'CODING': 'Code',
      'STUDY': 'Học bài',
      'SOCIAL_MEDIA': 'Lướt mạng',
      'EATING': 'Ăn uống',
      'WORKOUT': 'Tập thể dục',
      'RELAX': 'Thư giãn',
      'OTHER': 'Khác',
    };

    final peopleMap = {
      'ALONE': 'Một mình',
      'COWORKERS': 'Đồng nghiệp',
      'BOSS': 'Sếp',
      'FAMILY': 'Gia đình',
      'FRIENDS': 'Bạn bè',
      'PARTNER': 'Người yêu',
      'OTHER': 'Khác',
    };

    // Parse timestamp
    // Server backend có thể trả về:
    // 1. UTC time với 'Z' suffix: "2025-12-01T08:00:00Z"
    // 2. UTC time với offset: "2025-12-01T08:00:00+00:00"
    // 3. Local time không có timezone: "2025-12-01T08:00:00" (server đã dùng timezone của nó)
    //
    // Đặt true nếu server trả về UTC nhưng không có 'Z', false nếu server trả về local time
    const bool serverUsesUtcWithoutMarker = true;

    DateTime parsedTime;
    final timeString = json['createdAt'] ?? json['timestamp'];
    if (timeString != null && timeString.toString().isNotEmpty) {
      try {
        final timeStr = timeString.toString();
        parsedTime = DateTime.parse(timeStr);

        print('DEBUG PARSE TIME: Raw: $timeStr, Parsed: $parsedTime, isUtc: ${parsedTime.isUtc}');

        if (parsedTime.isUtc) {
          // Đã có timezone marker (Z hoặc +00:00), convert sang local
          parsedTime = parsedTime.toLocal();
        } else if (serverUsesUtcWithoutMarker &&
                   !timeStr.endsWith('Z') &&
                   !timeStr.contains('+') &&
                   !RegExp(r'-\d{2}:\d{2}$').hasMatch(timeStr)) {
          // Server trả về UTC nhưng không có timezone marker
          // Treat as UTC và convert sang local
          parsedTime = DateTime.utc(
            parsedTime.year,
            parsedTime.month,
            parsedTime.day,
            parsedTime.hour,
            parsedTime.minute,
            parsedTime.second,
            parsedTime.millisecond,
          ).toLocal();
        }
        // Nếu serverUsesUtcWithoutMarker = false, giữ nguyên parsedTime (server đã gửi local time)

        print('DEBUG PARSE TIME: Final local time: $parsedTime');
      } catch (e) {
        print('ERROR parsing timestamp: $timeString - $e');
        parsedTime = DateTime.now();
      }
    } else {
      parsedTime = DateTime.now();
    }

    return CheckIn(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      emotion: vietnameseEmotion,
      timestamp: parsedTime,
      note: json['note'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      location: locationTag != null ? (locationMap[locationTag] ?? locationTag) : null,
      activity: activityTag != null ? (activityMap[activityTag] ?? activityTag) : null,
      people: peopleTag != null ? (peopleMap[peopleTag] ?? peopleTag) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'emotion': emotion,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
      'tags': tags,
      'location': location,
      'activity': activity,
      'people': people,
    };
  }

  // Helper để lấy màu theo cảm xúc
  static EmotionStyle getEmotionStyle(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'lo lắng':
      case 'anxious':
      case 'worried':
        return EmotionStyle(
          label: 'Lo lắng',
          color: const Color(0xFF9333EA),
          backgroundColor: const Color(0xFFFAF5FF),
          borderColor: const Color(0xFFE9D5FF),
        );
      case 'giận dữ':
      case 'angry':
        return EmotionStyle(
          label: 'Giận dữ',
          color: const Color(0xFFFB2C36),
          backgroundColor: const Color(0xFFFFF5F5),
          borderColor: const Color(0xFFFFD6D6),
        );
      case 'căng thẳng':
      case 'stressed':
        return EmotionStyle(
          label: 'Căng thẳng',
          color: const Color(0xFFFF6900),
          backgroundColor: const Color(0xFFFFFAF5),
          borderColor: const Color(0xFFFFD6A7),
        );
      case 'vui vẻ':
      case 'happy':
      case 'hạnh phúc':
        return EmotionStyle(
          label: 'Hạnh phúc',
          color: const Color(0xFF10B981),
          backgroundColor: const Color(0xFFF0FDF4),
          borderColor: const Color(0xFFBBF7D0),
        );
      case 'bình thường':
      case 'neutral':
        return EmotionStyle(
          label: 'Bình thường',
          color: const Color(0xFF6366F1),
          backgroundColor: const Color(0xFFF5F7FF),
          borderColor: const Color(0xFFDDD6FE),
        );
      case 'buồn':
      case 'sad':
        return EmotionStyle(
          label: 'Buồn',
          color: const Color(0xFF3B82F6),
          backgroundColor: const Color(0xFFEFF6FF),
          borderColor: const Color(0xFFBFDBFE),
        );
      default:
        return EmotionStyle(
          label: emotion,
          color: const Color(0xFF6B7280),
          backgroundColor: const Color(0xFFF9FAFB),
          borderColor: const Color(0xFFE5E7EB),
        );
    }
  }
}

class EmotionStyle {
  final String label;
  final Color color;
  final Color backgroundColor;
  final Color borderColor;

  EmotionStyle({
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.borderColor,
  });
}

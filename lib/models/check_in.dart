import 'package:flutter/material.dart';

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
    return CheckIn(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      emotion: json['emotion'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      note: json['note'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      location: json['location'],
      activity: json['activity'],
      people: json['people'],
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

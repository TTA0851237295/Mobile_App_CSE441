import 'package:flutter/foundation.dart';
import '../models/check_in.dart';

/// Provider để quản lý lịch sử check-in
class CheckInProvider extends ChangeNotifier {
  final List<CheckIn> _checkIns = [];
  String? _latestAdvice;

  List<CheckIn> get checkIns => List.unmodifiable(_checkIns);
  String? get latestAdvice => _latestAdvice;

  // Lưu lời khuyên mới nhất
  void setLatestAdvice(String advice) {
    _latestAdvice = advice;
    notifyListeners();
  }

  // Lấy tất cả check-in trong ngày hôm nay
  List<CheckIn> getTodayCheckIns() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return _checkIns.where((checkIn) {
      return checkIn.timestamp.isAfter(todayStart) &&
          checkIn.timestamp.isBefore(todayEnd);
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Mới nhất lên đầu
  }

  // Thêm check-in mới
  void addCheckIn(CheckIn checkIn) {
    _checkIns.add(checkIn);
    notifyListeners();
  }

  // Đếm số lượng check-in hôm nay
  int getTodayCheckInCount() {
    return getTodayCheckIns().length;
  }

  // Lấy cảm xúc trội nhất trong ngày (xuất hiện nhiều nhất)
  String? getDominantEmotionToday() {
    final todayCheckIns = getTodayCheckIns();
    if (todayCheckIns.isEmpty) return null;

    // Đếm số lần xuất hiện của mỗi cảm xúc
    final emotionCount = <String, int>{};
    for (var checkIn in todayCheckIns) {
      emotionCount[checkIn.emotion] = (emotionCount[checkIn.emotion] ?? 0) + 1;
    }

    // Tìm cảm xúc xuất hiện nhiều nhất
    var maxCount = 0;
    String? dominantEmotion;
    emotionCount.forEach((emotion, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantEmotion = emotion;
      }
    });

    return dominantEmotion;
  }

  // Xóa tất cả check-in (dùng cho testing)
  void clearAll() {
    _checkIns.clear();
    notifyListeners();
  }
}


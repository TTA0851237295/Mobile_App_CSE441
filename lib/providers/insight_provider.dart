import 'package:flutter/material.dart';
import '../models/check_in.dart';
import '../providers/checkin_provider.dart';

/// Model cho correlation insights
class CorrelationInsight {
  final String emoji;
  final String title;
  final String reliabilityText;
  final Color reliabilityColor;
  final Color reliabilityBorderColor;
  final String description;
  final String chipLabel;
  final double reliability;

  CorrelationInsight({
    required this.emoji,
    required this.title,
    required this.reliabilityText,
    required this.reliabilityColor,
    required this.reliabilityBorderColor,
    required this.description,
    required this.chipLabel,
    required this.reliability,
  });
}

class InsightProvider extends ChangeNotifier {
  final CheckinProvider checkinProvider;
  
  List<CorrelationInsight> _insights = [];
  int _totalCheckIns = 0;
  bool _isCalculating = false;

  List<CorrelationInsight> get insights => _insights;
  int get totalCheckIns => _totalCheckIns;
  bool get isCalculating => _isCalculating;

  InsightProvider({required this.checkinProvider}) {
    // Listen to checkin changes
    checkinProvider.addListener(_onCheckinsUpdated);
  }

  void _onCheckinsUpdated() {
    calculateInsights();
  }

  @override
  void dispose() {
    checkinProvider.removeListener(_onCheckinsUpdated);
    super.dispose();
  }

  /// Tính toán tất cả correlations từ check-in data
  Future<void> calculateInsights() async {
    _isCalculating = true;
    notifyListeners();

    try {
      final checkins = checkinProvider.checkins;
      _totalCheckIns = checkins.length;

      print('DEBUG INSIGHTS: Total checkins = ${checkins.length}');

      if (checkins.isEmpty) {
        _insights = [];
        _isCalculating = false;
        notifyListeners();
        return;
      }

      // Filter check-ins from last 30 days
      final now = DateTime.now();
      final last30Days = now.subtract(const Duration(days: 30));
      final recentCheckins = checkins.where((c) => c.timestamp.isAfter(last30Days)).toList();

      print('DEBUG INSIGHTS: Recent checkins (30 days) = ${recentCheckins.length}');
      for (var checkin in recentCheckins) {
        print('  - ${checkin.timestamp}: ${checkin.emotion}, Activity=${checkin.activity}, People=${checkin.people}, Location=${checkin.location}');
      }

      List<CorrelationInsight> calculatedInsights = [];

      // 1. Activity Correlation
      final activityInsight = _calculateActivityCorrelation(recentCheckins);
      if (activityInsight != null) {
        print('DEBUG INSIGHTS: Activity insight found');
        calculatedInsights.add(activityInsight);
      }

      // 2. People Correlation
      final peopleInsight = _calculatePeopleCorrelation(recentCheckins);
      if (peopleInsight != null) {
        print('DEBUG INSIGHTS: People insight found');
        calculatedInsights.add(peopleInsight);
      }

      // 3. Time Correlation
      final timeInsight = _calculateTimeCorrelation(recentCheckins);
      if (timeInsight != null) {
        print('DEBUG INSIGHTS: Time insight found');
        calculatedInsights.add(timeInsight);
      }

      // 4. Location Correlation
      final locationInsight = _calculateLocationCorrelation(recentCheckins);
      if (locationInsight != null) {
        print('DEBUG INSIGHTS: Location insight found');
        calculatedInsights.add(locationInsight);
      }

      print('DEBUG INSIGHTS: Total insights calculated = ${calculatedInsights.length}');

      // Sort by reliability (highest first)
      calculatedInsights.sort((a, b) => b.reliability.compareTo(a.reliability));

      _insights = calculatedInsights;
      _isCalculating = false;
      notifyListeners();
    } catch (e) {
      print('Error calculating insights: $e');
      _isCalculating = false;
      notifyListeners();
    }
  }

  /// Tính correlation với hoạt động
  CorrelationInsight? _calculateActivityCorrelation(List<CheckIn> checkins) {
    if (checkins.isEmpty) return null;

    // Phân loại cảm xúc thành positive/negative
    final negativeEmotions = {'Lo lắng', 'Giận dữ', 'Căng thẳng', 'Buồn bã'};
    final positiveEmotions = {'Vui vẻ', 'Hạnh phúc'};

    // Map activity -> {positive: count, negative: count}
    Map<String, Map<String, int>> activityEmotions = {};

    for (var checkin in checkins) {
      if (checkin.activity == null || checkin.activity!.isEmpty) continue;

      final activity = checkin.activity!;
      activityEmotions.putIfAbsent(activity, () => {'positive': 0, 'negative': 0});

      if (negativeEmotions.contains(checkin.emotion)) {
        activityEmotions[activity]!['negative'] = activityEmotions[activity]!['negative']! + 1;
      } else if (positiveEmotions.contains(checkin.emotion)) {
        activityEmotions[activity]!['positive'] = activityEmotions[activity]!['positive']! + 1;
      }
    }

    if (activityEmotions.isEmpty) return null;

    // Find activity with highest negative correlation
    String? mostNegativeActivity;
    double highestNegativeRatio = 0;
    int negativeCount = 0;
    int totalCount = 0;

    activityEmotions.forEach((activity, counts) {
      final neg = counts['negative']!;
      final pos = counts['positive']!;
      final total = neg + pos;
      
      if (total < 2) return; // Skip if too few data points

      final ratio = neg / total;
      if (ratio > highestNegativeRatio) {
        highestNegativeRatio = ratio;
        mostNegativeActivity = activity;
        negativeCount = neg;
        totalCount = total;
      }
    });

    if (mostNegativeActivity == null || highestNegativeRatio < 0.5) return null;

    final reliability = (highestNegativeRatio * 100).round();
    final reliabilityColor = _getReliabilityColor(reliability);

    return CorrelationInsight(
      emoji: '🎯',
      title: 'Tương quan Hoạt động',
      reliabilityText: '$reliability% tin cậy',
      reliabilityColor: reliabilityColor,
      reliabilityBorderColor: _getReliabilityBorderColor(reliability),
      description:
          'Tâm An nhận thấy: $reliability% các lần bạn check-in cảm xúc tiêu cực ($negativeCount/$totalCount lần) đều liên quan đến hoạt động [$mostNegativeActivity]. Có thể đây là một tác nhân gây căng thẳng cho bạn.',
      chipLabel: 'Tương quan Hoạt động',
      reliability: reliability.toDouble(),
    );
  }

  /// Tính correlation với con người
  CorrelationInsight? _calculatePeopleCorrelation(List<CheckIn> checkins) {
    if (checkins.isEmpty) return null;

    final negativeEmotions = {'Lo lắng', 'Giận dữ', 'Căng thẳng', 'Buồn bã'};
    final positiveEmotions = {'Vui vẻ', 'Hạnh phúc'};

    Map<String, Map<String, int>> peopleEmotions = {};

    for (var checkin in checkins) {
      if (checkin.people == null || checkin.people!.isEmpty) continue;

      final people = checkin.people!;
      peopleEmotions.putIfAbsent(people, () => {'positive': 0, 'negative': 0});

      if (negativeEmotions.contains(checkin.emotion)) {
        peopleEmotions[people]!['negative'] = peopleEmotions[people]!['negative']! + 1;
      } else if (positiveEmotions.contains(checkin.emotion)) {
        peopleEmotions[people]!['positive'] = peopleEmotions[people]!['positive']! + 1;
      }
    }

    if (peopleEmotions.isEmpty) return null;

    // Find most positive and most negative
    String? mostPositivePeople;
    double highestPositiveRatio = 0;
    String? mostNegativePeople;
    double highestNegativeRatio = 0;

    peopleEmotions.forEach((people, counts) {
      final neg = counts['negative']!;
      final pos = counts['positive']!;
      final total = neg + pos;
      
      if (total < 2) return;

      final positiveRatio = pos / total;
      final negativeRatio = neg / total;

      if (positiveRatio > highestPositiveRatio) {
        highestPositiveRatio = positiveRatio;
        mostPositivePeople = people;
      }

      if (negativeRatio > highestNegativeRatio) {
        highestNegativeRatio = negativeRatio;
        mostNegativePeople = people;
      }
    });

    if (mostPositivePeople == null && mostNegativePeople == null) return null;

    final reliability = ((highestPositiveRatio + highestNegativeRatio) / 2 * 100).round();
    final reliabilityColor = _getReliabilityColor(reliability);

    String description = '';
    if (mostPositivePeople != null && highestPositiveRatio >= 0.6) {
      final percent = (highestPositiveRatio * 100).round();
      description += 'Bạn có vẻ tích cực hơn khi ở cùng [$mostPositivePeople] ($percent% check-in tích cực). ';
    }
    if (mostNegativePeople != null && highestNegativeRatio >= 0.6) {
      final percent = (highestNegativeRatio * 100).round();
      description += 'Cảm xúc tiêu cực tăng cao khi ở với [$mostNegativePeople] ($percent%).';
    }

    if (description.isEmpty) return null;

    return CorrelationInsight(
      emoji: '👥',
      title: 'Tương quan Con người',
      reliabilityText: '$reliability% tin cậy',
      reliabilityColor: reliabilityColor,
      reliabilityBorderColor: _getReliabilityBorderColor(reliability),
      description: description,
      chipLabel: 'Tương quan Con người',
      reliability: reliability.toDouble(),
    );
  }

  /// Tính correlation với thời gian
  CorrelationInsight? _calculateTimeCorrelation(List<CheckIn> checkins) {
    if (checkins.isEmpty) return null;

    final negativeEmotions = {'Lo lắng', 'Giận dữ', 'Căng thẳng', 'Buồn bã'};

    // Weekday correlation
    Map<int, Map<String, int>> weekdayEmotions = {};
    // Hour correlation
    Map<int, Map<String, int>> hourEmotions = {};

    for (var checkin in checkins) {
      final weekday = checkin.timestamp.weekday; // 1=Monday, 7=Sunday
      final hour = checkin.timestamp.hour;
      final isNegative = negativeEmotions.contains(checkin.emotion);

      weekdayEmotions.putIfAbsent(weekday, () => {'positive': 0, 'negative': 0});
      hourEmotions.putIfAbsent(hour, () => {'positive': 0, 'negative': 0});

      if (isNegative) {
        weekdayEmotions[weekday]!['negative'] = weekdayEmotions[weekday]!['negative']! + 1;
        hourEmotions[hour]!['negative'] = hourEmotions[hour]!['negative']! + 1;
      } else {
        weekdayEmotions[weekday]!['positive'] = weekdayEmotions[weekday]!['positive']! + 1;
        hourEmotions[hour]!['positive'] = hourEmotions[hour]!['positive']! + 1;
      }
    }

    // Find worst weekday
    int? worstWeekday;
    double highestWeekdayRatio = 0;

    weekdayEmotions.forEach((weekday, counts) {
      final neg = counts['negative']!;
      final total = neg + counts['positive']!;
      
      if (total < 2) return;

      final ratio = neg / total;
      if (ratio > highestWeekdayRatio) {
        highestWeekdayRatio = ratio;
        worstWeekday = weekday;
      }
    });

    // Find worst hour
    int? worstHour;
    double highestHourRatio = 0;

    hourEmotions.forEach((hour, counts) {
      final neg = counts['negative']!;
      final total = neg + counts['positive']!;
      
      if (total < 2) return;

      final ratio = neg / total;
      if (ratio > highestHourRatio) {
        highestHourRatio = ratio;
        worstHour = hour;
      }
    });

    if (worstWeekday == null && worstHour == null) return null;
    if (highestWeekdayRatio < 0.5 && highestHourRatio < 0.5) return null;

    final reliability = (((highestWeekdayRatio + highestHourRatio) / 2) * 100).round();
    final reliabilityColor = _getReliabilityColor(reliability);

    final weekdayNames = ['', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    
    String description = 'Tâm An phát hiện: ';
    if (worstWeekday != null && highestWeekdayRatio >= 0.5) {
      final percent = (highestWeekdayRatio * 100).round();
      description += 'Cảm xúc tiêu cực của bạn thường xuất hiện vào ${weekdayNames[worstWeekday!]} ($percent%). ';
    }
    if (worstHour != null && highestHourRatio >= 0.5) {
      final percent = (highestHourRatio * 100).round();
      description += 'Bạn thường cảm thấy căng thẳng vào khoảng ${worstHour!}h ($percent%).';
    }

    return CorrelationInsight(
      emoji: '⏰',
      title: 'Tương quan Thời gian',
      reliabilityText: '$reliability% tin cậy',
      reliabilityColor: reliabilityColor,
      reliabilityBorderColor: _getReliabilityBorderColor(reliability),
      description: description,
      chipLabel: 'Tương quan Thời gian',
      reliability: reliability.toDouble(),
    );
  }

  /// Tính correlation với địa điểm
  CorrelationInsight? _calculateLocationCorrelation(List<CheckIn> checkins) {
    if (checkins.isEmpty) return null;

    final negativeEmotions = {'Lo lắng', 'Giận dữ', 'Căng thẳng', 'Buồn bã'};

    Map<String, Map<String, int>> locationEmotions = {};

    for (var checkin in checkins) {
      if (checkin.location == null || checkin.location!.isEmpty) continue;

      final location = checkin.location!;
      locationEmotions.putIfAbsent(location, () => {'positive': 0, 'negative': 0});

      if (negativeEmotions.contains(checkin.emotion)) {
        locationEmotions[location]!['negative'] = locationEmotions[location]!['negative']! + 1;
      } else {
        locationEmotions[location]!['positive'] = locationEmotions[location]!['positive']! + 1;
      }
    }

    if (locationEmotions.isEmpty) return null;

    String? worstLocation;
    double highestNegativeRatio = 0;
    int negativeCount = 0;
    int totalCount = 0;

    locationEmotions.forEach((location, counts) {
      final neg = counts['negative']!;
      final pos = counts['positive']!;
      final total = neg + pos;
      
      if (total < 2) return;

      final ratio = neg / total;
      if (ratio > highestNegativeRatio) {
        highestNegativeRatio = ratio;
        worstLocation = location;
        negativeCount = neg;
        totalCount = total;
      }
    });

    if (worstLocation == null || highestNegativeRatio < 0.5) return null;

    final reliability = (highestNegativeRatio * 100).round();
    final reliabilityColor = _getReliabilityColor(reliability);

    return CorrelationInsight(
      emoji: '📍',
      title: 'Tương quan Địa điểm',
      reliabilityText: '$reliability% tin cậy',
      reliabilityColor: reliabilityColor,
      reliabilityBorderColor: _getReliabilityBorderColor(reliability),
      description:
          '$reliability% các lần check-in tiêu cực của bạn ($negativeCount/$totalCount lần) xảy ra tại [$worstLocation]. Môi trường này có thể đang ảnh hưởng đến tâm trạng của bạn.',
      chipLabel: 'Tương quan Địa điểm',
      reliability: reliability.toDouble(),
    );
  }

  Color _getReliabilityColor(int percent) {
    if (percent >= 80) return const Color(0xFF00A63E); // Green
    if (percent >= 60) return const Color(0xFFD08700); // Orange
    return const Color(0xFF6B7280); // Gray
  }

  Color _getReliabilityBorderColor(int percent) {
    if (percent >= 80) return const Color(0xFFB8F7CF); // Light green
    if (percent >= 60) return const Color(0xFFFEEF85); // Light orange
    return const Color(0xFFE5E7EB); // Light gray
  }
}

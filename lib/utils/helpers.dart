import 'package:intl/intl.dart';

class Helpers {
  // Date Formatting
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    // Format: "23:30 Th 7, 6 thg 12, 2025"
    final time = DateFormat('HH:mm').format(dateTime);
    final weekday = _getVietnameseWeekday(dateTime.weekday);
    final day = dateTime.day;
    final month = dateTime.month;
    final year = dateTime.year;

    return '$time $weekday, $day thg $month, $year';
  }

  static String _getVietnameseWeekday(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Th 2';
      case DateTime.tuesday:
        return 'Th 3';
      case DateTime.wednesday:
        return 'Th 4';
      case DateTime.thursday:
        return 'Th 5';
      case DateTime.friday:
        return 'Th 6';
      case DateTime.saturday:
        return 'Th 7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }

  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateOnly).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Hôm qua';
    } else {
      return formatDate(date);
    }
  }

  // Validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  // Export helpers
  static String generateCSV(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return '';

    final headers = data.first.keys.join(',');
    final rows = data.map((row) {
      return row.values.map((value) => '"$value"').join(',');
    }).join('\n');

    return '$headers\n$rows';
  }

  // Color helpers
  static String colorToHex(int color) {
    return '#${color.toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}

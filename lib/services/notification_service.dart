import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _notificationFrequencyKey = 'notification_frequency';
  static const String _notificationSoundKey = 'notification_sound';
  static const String _notificationTimesKey = 'notification_times';

  // Callback khi người dùng tap vào notification
  static Function(String?)? onNotificationTap;

  // Pending payload khi app chưa sẵn sàng
  static String? pendingPayload;

  Future<void> init() async {
    // Không khởi tạo trên web vì không hỗ trợ
    if (kIsWeb) return;

    // Khởi tạo timezone
    tz_data.initializeTimeZones();

    // Cấu hình cho Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Cấu hình cho iOS
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Xử lý khi bấm vào notification hoặc action button
        String? effectivePayload = response.payload;

        // Nếu bấm vào action button "Check-in ngay", cũng dùng payload checkin_reminder
        if (response.actionId == 'checkin_action') {
          effectivePayload = 'checkin_reminder';
        }

        if (onNotificationTap != null) {
          onNotificationTap!(effectivePayload);
        } else {
          // Lưu pending payload nếu callback chưa được set
          pendingPayload = effectivePayload;
        }
      },
    );

    // Kiểm tra nếu app được mở từ notification
    final launchDetails = await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null) {
        pendingPayload = payload;
      }
    }

    // Request permissions cho Android 13+
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) return;

    // Android
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    // iOS
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  // Hiển thị thông báo ngay lập tức
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
    bool enableSound = true,
  }) async {
    if (kIsWeb) return;

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'taman_checkin_channel',
      'Check-in Nhắc nhở',
      channelDescription: 'Thông báo nhắc nhở check-in cảm xúc',
      importance: Importance.high,
      priority: Priority.high,
      playSound: enableSound,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF9333EA),
      styleInformation: BigTextStyleInformation(body),
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'checkin_action',
          'Check-in ngay',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: enableSound,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Lên lịch thông báo cho một thời điểm cụ thể
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    bool enableSound = true,
  }) async {
    if (kIsWeb) return;

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'taman_checkin_channel',
      'Check-in Nhắc nhở',
      channelDescription: 'Thông báo nhắc nhở check-in cảm xúc',
      importance: Importance.high,
      priority: Priority.high,
      playSound: enableSound,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF9333EA),
      styleInformation: BigTextStyleInformation(body),
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'checkin_action',
          'Check-in ngay',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: enableSound,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  // Lên lịch thông báo hàng ngày tại thời điểm cụ thể
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    bool enableSound = true,
  }) async {
    if (kIsWeb) return;

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'taman_checkin_channel',
      'Check-in Nhắc nhở',
      channelDescription: 'Thông báo nhắc nhở check-in cảm xúc',
      importance: Importance.high,
      priority: Priority.high,
      playSound: enableSound,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF9333EA),
      styleInformation: BigTextStyleInformation(body),
      actions: <AndroidNotificationAction>[
        const AndroidNotificationAction(
          'checkin_action',
          'Check-in ngay',
          showsUserInterface: true,
          cancelNotification: true,
        ),
      ],
    );

    DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: enableSound,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // Hủy một thông báo cụ thể
  Future<void> cancelNotification(int id) async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancel(id);
  }

  // Hủy tất cả thông báo
  Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancelAll();
  }

  // Lấy danh sách thông báo đang chờ
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (kIsWeb) return [];
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  // === CÁC HÀM QUẢN LÝ CÀI ĐẶT ===

  // Lưu cài đặt thông báo
  Future<void> saveNotificationSettings({
    required bool enabled,
    required int frequency,
    required bool soundEnabled,
    List<String>? customTimes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    await prefs.setInt(_notificationFrequencyKey, frequency);
    await prefs.setBool(_notificationSoundKey, soundEnabled);
    if (customTimes != null) {
      await prefs.setStringList(_notificationTimesKey, customTimes);
    }

    // Cập nhật lịch thông báo
    await updateScheduledNotifications(
      enabled: enabled,
      frequency: frequency,
      soundEnabled: soundEnabled,
      customTimes: customTimes,
    );
  }

  // Đọc cài đặt thông báo
  Future<Map<String, dynamic>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'enabled': prefs.getBool(_notificationsEnabledKey) ?? true,
      'frequency': prefs.getInt(_notificationFrequencyKey) ?? 3,
      'soundEnabled': prefs.getBool(_notificationSoundKey) ?? true,
      'customTimes': prefs.getStringList(_notificationTimesKey),
    };
  }

  // Cập nhật lịch thông báo dựa trên tần suất
  Future<void> updateScheduledNotifications({
    required bool enabled,
    required int frequency,
    required bool soundEnabled,
    List<String>? customTimes,
  }) async {
    // Hủy tất cả thông báo hiện tại
    await cancelAllNotifications();

    if (!enabled) return;

    // Danh sách các thời điểm mặc định theo tần suất
    List<Map<String, int>> defaultTimes;

    switch (frequency) {
      case 1:
        defaultTimes = [
          {'hour': 20, 'minute': 0}, // 8:00 PM
        ];
        break;
      case 2:
        defaultTimes = [
          {'hour': 9, 'minute': 0},  // 9:00 AM
          {'hour': 20, 'minute': 0}, // 8:00 PM
        ];
        break;
      case 3:
        defaultTimes = [
          {'hour': 9, 'minute': 0},  // 9:00 AM
          {'hour': 14, 'minute': 0}, // 2:00 PM
          {'hour': 20, 'minute': 0}, // 8:00 PM
        ];
        break;
      case 4:
        defaultTimes = [
          {'hour': 8, 'minute': 0},  // 8:00 AM
          {'hour': 12, 'minute': 0}, // 12:00 PM
          {'hour': 17, 'minute': 0}, // 5:00 PM
          {'hour': 21, 'minute': 0}, // 9:00 PM
        ];
        break;
      default:
        defaultTimes = [
          {'hour': 9, 'minute': 0},
          {'hour': 14, 'minute': 0},
          {'hour': 20, 'minute': 0},
        ];
    }

    // Nếu có custom times, parse và sử dụng
    if (customTimes != null && customTimes.isNotEmpty) {
      defaultTimes = customTimes.map((time) {
        final parts = time.split(':');
        return {
          'hour': int.parse(parts[0]),
          'minute': int.parse(parts[1]),
        };
      }).toList();
    }

    // Danh sách các tin nhắn nhắc nhở
    final List<String> reminderMessages = [
      'Bạn đang cảm thấy thế nào? 🌟',
      'Dành một phút để ghi lại cảm xúc của bạn 💭',
      'Check-in nhanh nhé? 🎯',
      'Hãy theo dõi sức khỏe tinh thần của bạn 🧘',
      'Một ngày của bạn đang diễn ra như thế nào? 🌈',
      'Đừng quên check-in hôm nay! ✨',
      'Ghi lại khoảnh khắc này của bạn 📝',
    ];

    // Lên lịch thông báo cho từng thời điểm
    for (int i = 0; i < defaultTimes.length; i++) {
      final time = defaultTimes[i];
      final message = reminderMessages[i % reminderMessages.length];

      await scheduleDailyNotification(
        id: i + 1,
        title: 'Tâm An',
        body: message,
        hour: time['hour']!,
        minute: time['minute']!,
        payload: 'checkin_reminder',
        enableSound: soundEnabled,
      );
    }
  }

  // Kiểm tra và khởi tạo thông báo từ settings đã lưu
  Future<void> initFromSavedSettings() async {
    final settings = await getNotificationSettings();
    await updateScheduledNotifications(
      enabled: settings['enabled'] as bool,
      frequency: settings['frequency'] as int,
      soundEnabled: settings['soundEnabled'] as bool,
      customTimes: settings['customTimes'] as List<String>?,
    );
  }

  // Tính thời gian hiển thị đẹp cho notification time
  String getTimeDisplay(int hour, int minute) {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }

  // Lấy danh sách thời gian mặc định theo tần suất
  List<String> getDefaultTimesForFrequency(int frequency) {
    switch (frequency) {
      case 1:
        return ['20:00'];
      case 2:
        return ['09:00', '20:00'];
      case 3:
        return ['09:00', '14:00', '20:00'];
      case 4:
        return ['08:00', '12:00', '17:00', '21:00'];
      default:
        return ['09:00', '14:00', '20:00'];
    }
  }
}


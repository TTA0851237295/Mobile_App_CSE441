import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auths_screen.dart';
import 'screens/user/journal_screen.dart';
import 'screens/user/more_screen.dart';
import 'screens/user/settings_screen.dart';
import 'screens/user/goals_screen.dart';
import 'screens/user/Check_in.dart';
import 'widgets/app_shell.dart';
import 'providers/auth_provider.dart';
import 'providers/checkin_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/insight_provider.dart';
import 'providers/theme_provider.dart';
import 'config/app_theme.dart';
import 'services/notification_service.dart';

// Global navigator key để navigate từ notification
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo notification service
  final notificationService = NotificationService();
  await notificationService.init();

  // Khởi tạo thông báo từ cài đặt đã lưu
  await notificationService.initFromSavedSettings();

  runApp(const TamAnApp());
}

class TamAnApp extends StatefulWidget {
  const TamAnApp({super.key});

  @override
  State<TamAnApp> createState() => _TamAnAppState();
}

class _TamAnAppState extends State<TamAnApp> {
  @override
  void initState() {
    super.initState();
    // Setup callback sau khi widget đã mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupNotificationCallback();
      _checkPendingNotification();
    });
  }

  void _setupNotificationCallback() {
    NotificationService.onNotificationTap = (payload) {
      _handleNotificationTap(payload);
    };
  }

  void _checkPendingNotification() {
    // Kiểm tra và xử lý pending payload
    if (NotificationService.pendingPayload != null) {
      final payload = NotificationService.pendingPayload;
      NotificationService.pendingPayload = null;
      // Delay một chút để đảm bảo navigation đã sẵn sàng
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNotificationTap(payload);
      });
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload == 'checkin_reminder') {
      // Điều hướng đến màn hình chính (AppShell) để người dùng có thể chọn cảm xúc và check-in
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => AppShell(key: appShellKey),
        ),
        (route) => false, // Xóa tất cả các màn hình trước đó
      );
      // Đảm bảo chuyển đến tab Check-in sau khi navigation hoàn thành
      Future.delayed(const Duration(milliseconds: 100), () {
        appShellKey.currentState?.goToCheckInTab();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CheckinProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<CheckinProvider, InsightProvider>(
          create: (context) => InsightProvider(
            checkinProvider: context.read<CheckinProvider>(),
          ),
          update: (context, checkinProvider, previous) =>
              previous ?? InsightProvider(checkinProvider: checkinProvider),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthScreen(),
            routes: {
              '/login': (context) => const AuthScreen(),
              '/home': (context) => AppShell(key: appShellKey),
              '/journal': (context) => const JournalScreen(),
              '/more': (context) => const MoreScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/goals': (context) => const GoalsScreen(),
              '/checkin': (context) => const CheckInDetailScreen(selectedEmotion: 'Bình thường'),
            },
          );
        },
      ),
    );
  }
}

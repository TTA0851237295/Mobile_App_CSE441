import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/auths_screen.dart';
import 'screens/user/journal_screen.dart';
import 'screens/user/more_screen.dart';
import 'screens/user/settings_screen.dart';
import 'screens/user/goals_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/checkin_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/insight_provider.dart';
import 'providers/checkin_provider.dart';


void main() {
  runApp(const TamAnApp());
}

class TamAnApp extends StatelessWidget {
  const TamAnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CheckinProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProxyProvider<CheckinProvider, InsightProvider>(
          create: (context) => InsightProvider(
            checkinProvider: context.read<CheckinProvider>(),
          ),
          update: (context, checkinProvider, previous) =>
              previous ?? InsightProvider(checkinProvider: checkinProvider),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

      // ❗ Đây là màn sẽ chạy đầu tiên trong app
           home: const AuthScreen(),

           routes: {
             '/login': (context) => const AuthScreen(),
             '/journal': (context) => const JournalScreen(),
             '/more': (context) => const MoreScreen(),
             '/settings': (context) => const SettingsScreen(),
             '/goals': (context) => const GoalsScreen(),
           },
      ),
    );
  }
}

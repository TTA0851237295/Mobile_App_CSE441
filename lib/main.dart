import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // TODO: Uncomment when using MultiProvider
import 'screens/auth/auths_screen.dart';
import 'screens/user/journal_screen.dart';
import 'screens/user/more_screen.dart';
import 'screens/user/settings_screen.dart';
import 'screens/user/goals_screen.dart';


void main() {
  runApp(const TamAnApp());
}

class TamAnApp extends StatelessWidget {
  const TamAnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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


    );
  }
}

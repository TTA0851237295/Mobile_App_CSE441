import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // TODO: Uncomment when using MultiProvider
import 'screens/user/journal_screen.dart';
import 'screens/user/more_screen.dart';
import '/screens/user/insight.dart';
import '/screens/user/dashboard_screen.dart';
import '/widgets/app_shell.dart';


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

      home: const AppShell(),
      // Routes configuration
      routes: {
        '/journal': (context) => const JournalScreen(),
        '/more': (context) => const MoreScreen(),
      },

        
    
    );
  }
}

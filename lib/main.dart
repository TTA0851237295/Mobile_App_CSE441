import 'package:flutter/material.dart';
import 'package:mobileapp_taman/screens/user/insights.dart';
import 'package:mobileapp_taman/screens/user/dashboard_screen.dart';
import 'package:mobileapp_taman/widgets/layout/app_shell.dart';


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
        
    
    );
  }
}

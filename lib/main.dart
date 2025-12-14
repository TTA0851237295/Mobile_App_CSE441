import 'package:flutter/material.dart';
import 'package:mobileapp_taman/screens/auth/auths_screen.dart';


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

    
    );
  }
}

import 'package:flutter/material.dart';
import 'widgets/main_screen.dart';

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 250),
      ),
      home: const MainScreen(),
    );
  }
}


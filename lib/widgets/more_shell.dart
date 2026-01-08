import 'package:flutter/material.dart';
import '../screens/user/more_screen.dart';
import '../screens/user/journal_screen.dart';
import '../screens/user/goals_screen.dart';
import '../screens/user/settings_screen.dart';

class MoreShell extends StatefulWidget {
  const MoreShell({Key? key}) : super(key: key);

  @override
  State<MoreShell> createState() => _MoreShellState();
}

class _MoreShellState extends State<MoreShell> {
  int _currentSubIndex = 0; // 0: More, 1: Journal, 2: Goals, 3: Settings

  void _navigateToSubScreen(int index) {
    setState(() {
      _currentSubIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    switch (_currentSubIndex) {
      case 1:
        currentScreen = JournalScreen(onBack: () => _navigateToSubScreen(0));
        break;
      case 2:
        currentScreen = GoalsScreen(onBack: () => _navigateToSubScreen(0));
        break;
      case 3:
        currentScreen = SettingsScreen(onBack: () => _navigateToSubScreen(0));
        break;
      default:
        currentScreen = MoreScreen(
          onNavigateToJournal: () => _navigateToSubScreen(1),
          onNavigateToGoals: () => _navigateToSubScreen(2),
          onNavigateToSettings: () => _navigateToSubScreen(3),
        );
    }

    return currentScreen;
  }
}


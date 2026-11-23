import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// MainShell is the root layout after the app launches.
/// It holds the bottom NavigationBar and switches between the 4 main tabs.
/// It is a StatefulWidget because it needs to remember which tab is currently selected.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Tracks the active tab index (0 = Home, 1 = Learn, 2 = Practice, 3 = Profile)
  int _currentIndex = 0;

  // Placeholder widgets for each tab.
  // We will replace these one by one as we build each real screen.
  final List<Widget> _screens = const [
    Center(child: Text('Home Screen', style: TextStyle(fontSize: 20))),
    Center(child: Text('Learning Modules', style: TextStyle(fontSize: 20))),
    Center(child: Text('Practice Quiz', style: TextStyle(fontSize: 20))),
    Center(child: Text('My Progress', style: TextStyle(fontSize: 20))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea ensures content doesn't overlap with the phone's status bar or notch
      body: SafeArea(
        child: _screens[_currentIndex],
      ),

      // Material 3 bottom navigation bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        // Triggered whenever the user taps a tab; setState() rebuilds the UI
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.softPurple, // Pill highlight behind the active icon
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppTheme.primaryPurple),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: AppTheme.primaryPurple),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz, color: AppTheme.primaryPurple),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppTheme.primaryPurple),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
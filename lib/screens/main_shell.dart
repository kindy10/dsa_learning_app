import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'home_screen.dart';

/// MainShell is the root layout after the app launches.
/// It holds the bottom NavigationBar and switches between the 4 main tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Tracks the active tab index (0 = Home, 1 = Learn, 2 = Practice, 3 = Profile)
  int _currentIndex = 0;

  /// Helper method to switch tabs programmatically from child screens.
  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Built inside build() so we can pass the _switchTab callback to HomeScreen
    final List<Widget> screens = [
      HomeScreen(
        onNavigateToLearn: () => _switchTab(1),
        onNavigateToProfile: ()=> _switchTab(3),
        ),
      const Center(child: Text('Learning Modules', style: TextStyle(fontSize: 20))),
      const Center(child: Text('Practice Quiz', style: TextStyle(fontSize: 20))),
      const Center(child: Text('My Progress', style: TextStyle(fontSize: 20))),
    ];

    return Scaffold(
      body: SafeArea(
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _switchTab,
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.softPurple,
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
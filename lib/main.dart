// import 'package:flutter/material.dart';
// import 'core/theme/app_theme.dart';
// import 'screens/main_shell.dart';

// /// The entry point of every Flutter application.
// void main() {
//   runApp(const DsaLearningApp());
// }

// /// Root widget of the application.
// /// Configures the app title, global theme, and initial home screen.
// class DsaLearningApp extends StatelessWidget {
//   const DsaLearningApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DSA Learning',
//       // Hides the red "DEBUG" banner in the top-right corner
//       debugShowCheckedModeBanner: false,
//       // Applies our custom purple-and-white theme globally
//       theme: AppTheme.lightTheme,
//       // Loads the bottom navigation shell as the first screen
//       home: const MainShell(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'screens/register_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: RegisterScreen(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
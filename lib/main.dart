import 'package:flutter/material.dart';
import 'package:plentastic/screens/dashboard/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final greenTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
        secondary: Colors.lightGreen,
        surface: Colors.white,
      ),
    );

    return MaterialApp(
      title: 'Plentastic',
      themeMode: ThemeMode.light,
      theme: greenTheme,
      darkTheme: greenTheme,
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:plentastic/screens/dashboard/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plentastic',
      themeMode: ThemeMode.dark, // Set dark mode directly
      theme: ThemeData.light(),
      darkTheme: ThemeData.light(),
      home: const DashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

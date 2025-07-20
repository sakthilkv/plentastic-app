import 'package:flutter/material.dart';
import 'package:plentastic/screens/dashboard/home/home_page.dart';
import 'package:plentastic/screens/dashboard/leaderboard/leaderboard_page.dart';
import 'package:plentastic/screens/dashboard/scanner/scanner_page.dart';
import 'package:plentastic/screens/dashboard/store/store_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const LeaderboardPage(),
    const ScannerPage(),
    const StorePage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.emoji_events
                  : Icons.emoji_events_outlined,
            ),
            label: 'Ranking',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 2 ? Icons.qr_code_scanner : Icons.qr_code,
            ),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 3 ? Icons.store : Icons.store_outlined,
            ),
            label: 'Store',
          ),
          NavigationDestination(
            icon: Icon(
              _selectedIndex == 4 ? Icons.settings : Icons.settings_outlined,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Page'));
  }
}

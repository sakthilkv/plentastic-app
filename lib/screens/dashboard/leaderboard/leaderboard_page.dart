import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool isLoading = true;
  List<LeaderboardEntry> leaderboardEntries = [];

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay
    if (mounted) {
      setState(() {
        leaderboardEntries = [
          LeaderboardEntry(
              avatarUrl: 'https://example.com/avatar1.png',
              name: 'Alice',
              league: 'Gold'),
          LeaderboardEntry(
              avatarUrl: 'https://example.com/avatar2.png',
              name: 'Bob',
              league: 'Silver'),
          LeaderboardEntry(
              avatarUrl: 'https://example.com/avatar3.png',
              name: 'Charlie',
              league: 'Bronze'),
        ];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchLeaderboardData();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: leaderboardEntries.length,
              itemBuilder: (context, index) {
                final entry = leaderboardEntries[index];
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(entry.avatarUrl)),
                  title: Text(entry.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(entry.league,
                      style: const TextStyle(color: Colors.grey)),
                );
              },
            ),
    );
  }
}

class LeaderboardEntry {
  final String avatarUrl;
  final String name;
  final String league;

  LeaderboardEntry({
    required this.avatarUrl,
    required this.name,
    required this.league,
  });
}
  
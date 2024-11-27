import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plentastic/constants.dart';
import 'dart:convert';

class StatsCard extends StatefulWidget {
  const StatsCard({super.key});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  String points = 'Loading...';
  String league = 'Loading...';
  bool isLoading = true;

  // Function to fetch points and league from the server
  Future<void> fetchStats() async {
    // Fetch points
    final pointsResponse = await http.get(
        Uri.parse('${Constants.apiUrl}user/getpoint?uid=${Constants.userUID}'));

    // Fetch league
    final leagueResponse = await http.get(Uri.parse(
        '${Constants.apiUrl}user/getleague?uid=${Constants.userUID}'));

    if (pointsResponse.statusCode == 200 && leagueResponse.statusCode == 200) {
      // Parse the JSON responses
      final pointsData = json.decode(pointsResponse.body);
      final leagueData = json.decode(leagueResponse.body);

      setState(() {
        points = pointsData['points'].toString();
        league = leagueData['league'].toString();
        isLoading = false;
      });
    } else {
      setState(() {
        points = 'Error fetching data';
        league = 'Error fetching data';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStats(); // Fetch the stats when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(
              icon: Icons.star,
              title: 'Points',
              value: isLoading ? 'Loading...' : points,
              color: Colors.amber,
            ),
            _buildStatColumn(
              icon: Icons.shield,
              title: 'League',
              value: isLoading ? 'Loading...' : league,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16, // Smaller font size
            fontWeight: FontWeight.bold,
            color: Colors.black54, // Softer black for contrast
          ),
        ),
      ],
    );
  }
}

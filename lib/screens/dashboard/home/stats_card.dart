import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plentastic/constants.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({super.key});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  String points = 'Loading...';
  String league = 'Loading...';
  bool isLoading = true;

  Future<void> fetchStats() async {
    final pointsResponse = await http.get(
        Uri.parse('${Constants.apiUrl}user/getpoint?uid=${Constants.userUID}'));

    final leagueResponse = await http.get(Uri.parse(
        '${Constants.apiUrl}user/getleague?uid=${Constants.userUID}'));

    if (pointsResponse.statusCode == 200 && leagueResponse.statusCode == 200) {
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
    fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              color: Colors.black.withOpacity(0.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 40,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isLoading ? 'Loading...' : points,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Points',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/trophy-solid.svg',
                      width: 33,
                      height: 33,
                      color: const Color.fromARGB(255, 33, 192, 255),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isLoading ? 'Loading...' : league,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'League',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

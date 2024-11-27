import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plentastic/constants.dart';
import 'dart:convert';
import 'package:plentastic/screens/dashboard/home/stats_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String greeting = 'Hello, User 👋🏻!'; // Default greeting text

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Real data fetching function
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          '${Constants.apiUrl}user/getname?uid=${Constants.userUID}'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);

        // Update greeting and loading state based on the API response
        setState(() {
          greeting =
              'Hello, ${data['name']} 👋🏻!'; // Assuming the API returns the user's name
          isLoading = false;
        });
      } else {
        setState(() {
          greeting = 'Error fetching data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        greeting = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  '${Constants.apiUrl}/public/assets/user/${Constants.userUID}.png'),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      greeting,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // StatsCard
                const StatsCard(), // Keep StatsCard as is

                // New instructions section for taking and posting a picture, placed below StatsCard
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How to Take a Picture and Post It',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Step 1: Trash Bin Icon
                        _buildInstructionStep(
                          icon: Icons.delete_outline,
                          text: 'Find the right trash bin for plastic waste.',
                        ),

                        // Step 2: Camera Icon
                        _buildInstructionStep(
                          icon: Icons.camera_alt_outlined,
                          text:
                              'Take a clear picture of yourself disposing of plastic waste.',
                        ),

                        // Step 3: Visibility Icon
                        _buildInstructionStep(
                          icon: Icons.visibility,
                          text:
                              'Ensure the trash bin and waste are visible in the picture.',
                        ),

                        // Step 4: Upload Icon
                        _buildInstructionStep(
                          icon: Icons.upload,
                          text:
                              'Upload the picture in the app and earn points!',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Helper function to build each instruction step with an icon and text
  Widget _buildInstructionStep({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24), // Icon with color and size
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fill.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            AppBar(
              backgroundColor: Colors.black.withOpacity(0.1),
              systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.black87,
                statusBarColor: Colors.transparent,
              ),
              foregroundColor: Colors.white,
              title: const Text(
                'Home',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${Constants.apiUrl}public/assets/user/sakthi.png',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg-screen.jpg'), fit: BoxFit.cover),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          greeting,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const StatsCard(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
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
                              'How to take a picture and post it ?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildInstructionStep(
                              icon: Icons.delete_outline,
                              text:
                                  'Find the right trash bin for plastic waste.',
                            ),
                            _buildInstructionStep(
                              icon: Icons.camera_alt_outlined,
                              text:
                                  'Take a clear picture of yourself disposing of plastic waste.',
                            ),
                            _buildInstructionStep(
                              icon: Icons.visibility,
                              text:
                                  'Ensure the trash bin and waste are visible in the picture.',
                            ),
                            _buildInstructionStep(
                              icon: Icons.upload,
                              text:
                                  'Upload the picture in the app and earn points!',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 273)
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInstructionStep({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.yellow, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

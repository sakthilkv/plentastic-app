import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plentastic/constants.dart';
import 'dart:convert';

import 'package:plentastic/screens/dashboard/store/coupon_details_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool isLoading = true;
  int userPoints = 0;
  List<Map<String, dynamic>> coupons = [];

  @override
  void initState() {
    super.initState();
    fetchPoints();
  }

  Future<void> fetchPoints() async {
    final response = await http.get(
        Uri.parse('${Constants.apiUrl}user/getpoint?uid=${Constants.userUID}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        userPoints = responseData['points'];
      });

      fetchCoupons(userPoints);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCoupons(int points) async {
    final response = await http
        .get(Uri.parse('${Constants.apiUrl}store/getcoupons?points=$points'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        coupons = List<Map<String, dynamic>>.from(responseData.map((coupon) {
          return {
            'id': coupon['id'],
            'title': coupon['title'],
            'description': coupon['description'],
            'points': coupon['points'],
            'image': '${Constants.apiUrl}/${coupon['cover_url']}',
          };
        }));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet),
                const SizedBox(width: 8),
                Text(
                  'Points: $userPoints',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1 / 1.6,
                ),
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  final coupon = coupons[index];
                  return CouponCard(
                    id: coupon['id'],
                    title: coupon['title'],
                    description: coupon['description'],
                    points: coupon['points'],
                    image: coupon['image'] ?? 'https://via.placeholder.com/150',
                    userPoints: userPoints,
                  );
                },
              ),
            ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final int points;
  final String image;
  final int userPoints;

  const CouponCard({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.image,
    required this.userPoints,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isEligible = userPoints >= points;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(4.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('$points Points',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: isEligible
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CouponDetailPage(id: id),
                        ),
                      ).then((_) {
                        // Call fetchPoints on return to update points
                        if (context
                                .findAncestorStateOfType<_StorePageState>() !=
                            null) {
                          context
                              .findAncestorStateOfType<_StorePageState>()!
                              .fetchPoints();
                        }
                      });
                    }
                  : null,
              icon: const Icon(Icons.shopping_cart, size: 20),
              label: const Text('Redeem'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

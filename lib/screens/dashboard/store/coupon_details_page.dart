import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:plentastic/constants.dart'; // For decoding JSON response

class CouponDetailPage extends StatelessWidget {
  final String id; // The offer_id is passed in as the id parameter

  const CouponDetailPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchCouponDetails(id), // Fetch coupon details using the id
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Coupon Details'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Coupon Details'),
            ),
            body: const Center(child: Text("Failed to load coupon details")),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Coupon Details'),
            ),
            body: const Center(child: Text("Coupon not found.")),
          );
        } else {
          final couponData = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Coupon Details'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the cover image
                  Image.network(
                    '${Constants.apiUrl}/${couponData['cover_url']}' ??
                        'https://via.placeholder.com/150', // Show cover_url
                    height: 250,
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
                  const SizedBox(height: 16),
                  // The rest of the content
                  Text(
                    couponData['title'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    couponData['description'] ?? 'No description available.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Image.network(
                        couponData['companyLogo'] ??
                            'https://via.placeholder.com/40',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Text(
                        couponData['companyName'] ?? 'Company Name',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Be Safe and Follow Instructions:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Always check the expiration date on your coupons.\n'
                    '2. Ensure you meet all the requirements for redemption.\n'
                    '3. Follow any applicable safety protocols if visiting stores or using services.\n'
                    '4. Enjoy your discounts responsibly!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.deepPurple,
                child: TextButton.icon(
                  onPressed: () {
                    _showCouponDialog(context, couponData);
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Redeem',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _showCouponDialog(
      BuildContext context, Map<String, dynamic> couponData) async {
    // Perform the redeem operation and get the coupon token
    final couponToken =
        await _redeemCoupon(id); // Get coupon token after redeeming

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(couponData['title'] ?? 'Coupon Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.network(
                    couponData['companyLogo'] ??
                        'https://via.placeholder.com/40',
                    height: 40,
                    width: 40,
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
                  const SizedBox(width: 8),
                  Text(
                    couponData['companyName'] ?? 'Company Name',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                couponData['description'] ?? 'No description available.',
              ),
              const SizedBox(height: 16),
              const Text(
                'Coupon Code:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          couponToken ??
                              'N/A',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: couponToken ?? ''));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Coupon code copied!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.copy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _redeemCoupon(String offerId) async {
    const userId = Constants.userUID; // Get user ID from Constants

    // Construct the URL with user_id and offer_id
    final url = Uri.parse(
      '${Constants.apiUrl}/store/redeem?user_id=$userId&offer_id=$offerId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final couponToken = data['coupon_token'];

        return couponToken;
      } else {
        throw Exception('Failed to redeem coupon');
      }
    } on TimeoutException catch (_) {
      print('Error: Request timed out');
      return null;
    } catch (e) {
      print('Error: $e');
      return null; // Return null if error occurs
    }
  }

  Future<Map<String, dynamic>> _fetchCouponDetails(String id) async {
    final url = Uri.parse('${Constants.apiUrl}store/getcoupondetails?id=$id');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load coupon details');
      }
    } on TimeoutException catch (_) {
      print('Error: Request timed out');
      throw Exception('Request timed out');
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load coupon details');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:plentastic/constants.dart';
import 'package:plentastic/screens/dashboard/scanner/result_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  CameraDescription? firstCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  void _initializeCamera() async {
    cameras = await availableCameras();
    firstCamera = cameras?.first;

    _controller = CameraController(
      firstCamera!,
      ResolutionPreset.high,
    );

    // Initialize the camera
    await _controller?.initialize();

    // If the widget is still mounted, update the state
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Function to take a picture and navigate to the result screen
  void _takePicture() async {
    try {
      final image = await _controller?.takePicture();
      if (image != null) {
        print('Picture saved to ${image.path}');

        // Convert the image to PNG format
        final pngImage = await _convertToPng(image.path);

        // Send the PNG image to the Flask server for processing
        final result = await _sendImageToServer(pngImage);

        // After receiving the response, navigate to the result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  // Function to convert the captured image to PNG format
  Future<File> _convertToPng(String imagePath) async {
    // Load the image
    final img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Convert to PNG
    final pngBytes = img.encodePng(image);

    final dir = await Directory.systemTemp.createTemp();
    final newImagePath = '${dir.path}/converted_image1.png';
    final newImageFile = File(newImagePath)..writeAsBytesSync(pngBytes);

    return newImageFile;
  }

  Future<Map<String, dynamic>> _sendImageToServer(File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${Constants.apiUrl}scan/process_image'), // Use the API URL from Constants
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    request.fields['uid'] =
        Constants.userUID; // Use the user UID from Constants

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);
      return {
        'message': result['message'],
        'similarity': result['similarity'],
        'points': result['point'],
      };
    } else {
      return {
        'message': 'Error',
        'similarity': 0,
        'points': 0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show the live camera feed in the center of the screen
            SizedBox(
              width: 300,
              height: 550, // Set the height of the camera preview
              child: CameraPreview(_controller!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePicture, // Capture the image
              child: const Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}

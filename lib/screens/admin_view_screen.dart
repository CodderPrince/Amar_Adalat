import 'package:flutter/material.dart';

class AdminViewScreen extends StatefulWidget {
  @override
  _AdminViewScreenState createState() => _AdminViewScreenState();
}

class _AdminViewScreenState extends State<AdminViewScreen> {
  String imageUrl = '';
  String displayedImageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Image View')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter Image URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  imageUrl = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  displayedImageUrl = imageUrl;
                });
              },
              child: const Text('Load Image'),
            ),
            const SizedBox(height: 16),
            if (displayedImageUrl.isNotEmpty)
              Image.network(
                displayedImageUrl,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Failed to load image');
                },
              )
            else
              const Text('Enter an image URL and press "Load Image".'),
          ],
        ),
      ),
    );
  }
}
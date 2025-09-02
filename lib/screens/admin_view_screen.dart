import 'package:flutter/material.dart';

class AdminViewScreen extends StatefulWidget {
  @override
  _AdminViewScreenState createState() => _AdminViewScreenState();
}

class _AdminViewScreenState extends State<AdminViewScreen> {
  String imageUrl = '';
  String displayedImageUrl = '';
  bool _isLoadingImage = false; // New state to manage loading animation

  // Controller for the TextField for more control
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _loadImage() {
    setState(() {
      _isLoadingImage = true; // Start loading
      displayedImageUrl = ''; // Clear previous image
    });

    // Simulate network delay for loading, then set image
    // In a real app, this delay is naturally caused by network fetching.
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        displayedImageUrl = imageUrl; // Set the image URL to display
        _isLoadingImage = false; // Stop loading
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Image View', style: TextStyle(color: Colors.white)), // Colorful AppBar title
        backgroundColor: Colors.deepPurple, // Colorful AppBar background
        foregroundColor: Colors.white, // Ensures back button and text are white
        elevation: 8, // Add some shadow to the AppBar
      ),
      body: Container(
        decoration: BoxDecoration( // Gradient background for the body
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[50]!, Colors.blue[50]!], // Light gradient colors
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Increased padding
          child: Column(
            children: [
              // Animated TextField (subtle grow on focus)
              TextField(
                controller: _urlController,
                style: const TextStyle(color: Colors.deepPurple), // Text color
                cursorColor: Colors.deepPurpleAccent, // Cursor color
                decoration: InputDecoration(
                  labelText: 'Enter Image URL',
                  labelStyle: TextStyle(color: Colors.deepPurple[700]), // Label color
                  hintText: 'e.g., https://example.com/image.jpg',
                  hintStyle: TextStyle(color: Colors.deepPurple[300]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    borderSide: BorderSide(color: Colors.deepPurple, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.6), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2), // Highlight on focus
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.85), // Light fill color
                  prefixIcon: Icon(Icons.link, color: Colors.deepPurple[400]), // Icon
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Padding inside field
                ),
                onChanged: (value) {
                  setState(() {
                    imageUrl = value;
                  });
                },
              ),
              const SizedBox(height: 24), // Increased spacing
              // Animated Loading Button
              _isLoadingImage
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent), // Loader color
              )
                  : ElevatedButton.icon( // Using ElevatedButton.icon for a nicer look
                onPressed: imageUrl.isNotEmpty ? _loadImage : null, // Disable if URL is empty
                icon: const Icon(Icons.image),
                label: const Text('Load Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent, // Button background
                  foregroundColor: Colors.white, // Button text/icon color
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded button
                  ),
                  elevation: 7, // Shadow
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              // AnimatedSwitcher for image/placeholder text
              Expanded( // Use Expanded to fill available space
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500), // Fade animation duration
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child); // Simple fade
                  },
                  child: _buildImageDisplayWidget(context), // Extracted widget
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the image display content
  Widget _buildImageDisplayWidget(BuildContext context) {
    if (displayedImageUrl.isNotEmpty && !_isLoadingImage) {
      return Container(
        key: ValueKey(displayedImageUrl), // Unique key for AnimatedSwitcher
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // Clip image to rounded corners
        child: FadeInImage.assetNetwork( // Use FadeInImage for smooth loading
          placeholder: 'assets/image_placeholder.png', // You need to add a placeholder image
          image: displayedImageUrl,
          fit: BoxFit.contain, // Contain the image within the bounds
          imageErrorBuilder: (context, error, stackTrace) {
            debugPrint('Image loading error: $error'); // Log the error
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 60, color: Colors.red[400]),
                  const SizedBox(height: 10),
                  Text(
                    'Failed to load image: Invalid URL or network issue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[700], fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else if (_isLoadingImage) {
      // Show loading indicator in the image area while the image is being prepared
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
        ),
      );
    } else {
      return Center(
        key: const ValueKey('placeholder'), // Unique key for AnimatedSwitcher
        child: Text(
          'Enter an image URL above and press "Load Image" to view it.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.deepPurple[400]),
        ),
      );
    }
  }
}
import 'dart:io'; // Import dart:io

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart'; // Assuming supabase is initialized in main.dart
import 'package:image_picker/image_picker.dart'; // Import image_picker

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String issue = '';
  bool _isSubmitting = false;
  File? _image;

  // Controllers for TextFormFields for better management
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    } catch (e) {
      // Handle permission errors or other picker issues
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);
    try {
      String? imageUrl;

      if (_image != null) {
        // Show a temporary loading message for image upload if needed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading image...')),
          );
        }

        final bytes = await _image!.readAsBytes();
        final fileExt = _image!.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = 'reports/$fileName';

        await supabase.storage.from('reports').uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$fileExt'),
        );

        imageUrl = supabase.storage.from('reports').getPublicUrl(filePath);
      }

      await supabase.from('reports').insert({
        'title': title,
        'issue': issue,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully')),
        );
      }
      _formKey.currentState!.reset();
      _nameController.clear();
      _issueController.clear();
      setState(() => _image = null);
    } catch (e) {
      debugPrint('Error submitting report: $e'); // Log detailed error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issues', style: TextStyle(color: Colors.white)), // White title
        backgroundColor: Colors.deepPurple, // Deep purple AppBar
        foregroundColor: Colors.white, // White back button
        elevation: 8, // Add shadow
      ),
      // Ensure the Scaffold resizes to avoid keyboard overlap
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration( // Gradient background for the body
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[100]!, Colors.purple[50]!], // Light purple gradient
          ),
        ),
        child: SingleChildScrollView( // Make the form scrollable
          padding: const EdgeInsets.all(24.0), // Increased padding
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
              children: [
                // Your Name TextFormField
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.deepPurple), // Text color
                  cursorColor: Colors.deepPurpleAccent, // Cursor color
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: TextStyle(color: Colors.deepPurple[700]),
                    hintText: 'Enter your full name',
                    hintStyle: TextStyle(color: Colors.deepPurple[300]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.deepPurple, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.6), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.85),
                    prefixIcon: Icon(Icons.person, color: Colors.deepPurple[400]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
                  onSaved: (val) => title = val!,
                ),
                const SizedBox(height: 24), // Increased spacing

                // Describe Issue TextFormField
                TextFormField(
                  controller: _issueController,
                  style: const TextStyle(color: Colors.deepPurple),
                  cursorColor: Colors.deepPurpleAccent,
                  decoration: InputDecoration(
                    labelText: 'Describe Issue',
                    labelStyle: TextStyle(color: Colors.deepPurple[700]),
                    hintText: 'Please provide details of the issue...',
                    hintStyle: TextStyle(color: Colors.deepPurple[300]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.deepPurple, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.6), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.85),
                    prefixIcon: Icon(Icons.description, color: Colors.deepPurple[400]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  validator: (val) => val!.isEmpty ? 'Please describe the issue' : null,
                  onSaved: (val) => issue = val!,
                  maxLines: 5, // Allow more lines for description
                  minLines: 3,
                ),
                const SizedBox(height: 24),

                // Pick Image Button
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pick Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent, // Consistent button color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 7,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Image Preview
                if (_image != null)
                  Container(
                    alignment: Alignment.center, // Center the image
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.file(
                      _image!,
                      height: 150, // Slightly larger preview
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  const SizedBox.shrink(),

                // Submit Report Button or Loading Indicator
                _isSubmitting
                    ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent), // Loader color
                  ),
                )
                    : ElevatedButton.icon(
                  onPressed: _submitReport,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Slightly darker purple for submit
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 7,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
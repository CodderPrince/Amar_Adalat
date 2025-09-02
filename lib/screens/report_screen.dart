import 'dart:io'; // Import dart:io

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = ''; // Changed name to title
  String issue = '';
  bool _isSubmitting = false;
  File? _image; // Store the selected image file

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);
    try {
      String? imageUrl; // Store the image URL if uploaded

      if (_image != null) {
        // Upload the image to Supabase storage
        final bytes = await _image!.readAsBytes();
        final fileExt = _image!.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        final filePath = 'reports/$fileName'; // Define the storage path

        await supabase.storage.from('reports').uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(contentType: 'image/$fileExt'),
        );

        // Get the public URL of the uploaded image
        imageUrl = supabase.storage.from('reports').getPublicUrl(filePath);
      }

      await supabase.from('reports').insert({
        'title': title, // Use title here
        'issue': issue,
        'image_url': imageUrl, // Save the image URL in the database
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report submitted successfully')),
      );
      _formKey.currentState!.reset();
      setState(() => _image = null); // Clear the selected image
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit report: $e')),
      );
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report Issues')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                onSaved: (val) => title = val!, // Use title here
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Describe Issue'),
                validator: (val) => val!.isEmpty ? 'Enter issue' : null,
                onSaved: (val) => issue = val!,
                maxLines: 4,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 8),
              _image != null
                  ? Image.file(
                _image!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
                  : SizedBox.shrink(), // Show selected image
              SizedBox(height: 24),
              _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                  onPressed: _submitReport, child: Text('Submit Report')),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String? link;

  const DetailsScreen({
    Key? key,
    required this.title,
    this.subtitle,
    this.description,
    this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            SizedBox(height: 16),
            if (description != null)
              Text(
                description!,
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 24),
            if (link != null && link!.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  final uri = Uri.parse(link!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open link')),
                    );
                  }
                },
                child: Text('Open Link'),
              ),
          ],
        ),
      ),
    );
  }
}
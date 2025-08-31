import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String? link;

  const DetailsScreen({
    required this.title,
    this.subtitle,
    this.description,
    this.link,
    super.key,
  });

  Future<void> _openLink(BuildContext context) async {
    if (link == null || link!.isEmpty) return;

    final uri = Uri.parse(link!);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot open this link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to open link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subtitle != null && subtitle!.isNotEmpty)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (subtitle != null && subtitle!.isNotEmpty)
              const SizedBox(height: 12),
            if (description != null && description!.isNotEmpty)
              Text(
                description!,
                style: const TextStyle(fontSize: 16),
              ),
            if (description != null && description!.isNotEmpty)
              const SizedBox(height: 20),
            if (link != null && link!.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => _openLink(context),
                icon: const Icon(Icons.link),
                label: const Text('Open Link'),
              ),
          ],
        ),
      ),
    );
  }
}

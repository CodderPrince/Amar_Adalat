// lib/widgets/card_item.dart
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor; // Added background color
  final Color textColor; // Added text color

  const HomeCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    this.textColor = Colors.white, // Default to white text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: backgroundColor, // Use the provided background color
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: textColor), // Use textColor
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor), // Use textColor
              ),
            ],
          ),
        ),
      ),
    );
  }
}
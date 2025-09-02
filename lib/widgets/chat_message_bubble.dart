// lib/widgets/chat_message_bubble.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final String sender; // 'user' or 'bot'
  final DateTime timestamp;
  final bool isLoading;
  final List<String>? suggestions; // NEW: Optional list of suggested questions
  final ValueChanged<String>? onSuggestionTap; // NEW: Callback for suggestion taps

  const ChatMessageBubble({
    Key? key,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.isLoading = false,
    this.suggestions, // Initialize new properties
    this.onSuggestionTap, // Initialize new properties
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = sender == 'user';
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? theme.primaryColor.withOpacity(0.8) : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
            bottomLeft: isUser ? const Radius.circular(12.0) : const Radius.circular(2.0),
            bottomRight: isUser ? const Radius.circular(2.0) : const Radius.circular(12.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)),
            )
                : Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              DateFormat('hh:mm a').format(timestamp),
              style: TextStyle(
                color: isUser ? Colors.white70 : Colors.black54,
                fontSize: 10.0,
              ),
            ),
            // NEW: Display suggested questions if available
            if (suggestions != null && suggestions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0, // Horizontal space between chips
                runSpacing: 4.0, // Vertical space between lines of chips
                children: suggestions!.map((suggestion) => ActionChip(
                  label: Text(
                    suggestion,
                    style: TextStyle(
                      color: isUser ? Colors.deepPurple[900] : theme.primaryColor, // Adjusted color
                      fontSize: 13.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () => onSuggestionTap?.call(suggestion),
                  backgroundColor: isUser ? Colors.deepPurple[50] : Colors.grey[200], // Background of suggestion chip
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: isUser ? Colors.deepPurple[200]! : Colors.grey[400]!),
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
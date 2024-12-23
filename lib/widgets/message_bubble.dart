import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String senderName;
  final bool isMe;
  final DateTime timestamp;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.senderName,
    required this.isMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe) // Only show sender name for others' messages
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                senderName,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          BubbleSpecialThree(
            text: message,
            color: isMe ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
            tail: true,
            isSender: isMe,
            textStyle: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 16,
              right: isMe ? 16 : 0,
              top: 4,
            ),
            child: Text(
              DateFormat('HH:mm').format(timestamp),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
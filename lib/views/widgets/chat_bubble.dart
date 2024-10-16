import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime? dateTime;

  ChatBubble({
    required this.message,
    required this.isMe,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.blueAccent : Colors.grey[300];
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          );
    final textColor = isMe ? Colors.white : Colors.black87;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: radius,
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  (dateTime == null)
                      ? DateFormat('h:mm a').format(DateTime.now())
                      : DateFormat('h:mm a').format(dateTime!),
                  style: TextStyle(
                      color: textColor.withOpacity(0.7), fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

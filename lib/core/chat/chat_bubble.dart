import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByMe;

  ChatBubble({required this.text, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:  EdgeInsets.only(bottom:5,top: 5,left: isSentByMe ? 30:10,right: isSentByMe ? 10:30 ),//symmetric(vertical: 5, horizontal: 20)
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentByMe ? Colors.green[300] : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isSentByMe ? Radius.circular(15) : Radius.zero,
            bottomRight: isSentByMe ? Radius.zero : Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 10),
              child: Text(
                text,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Positioned(
              bottom: 0,
              right: isSentByMe ? 0 : null,
              left: isSentByMe ? null : 0,
              child: CustomPaint(
                painter: ChatBubbleTail(isSentByMe),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 📌 Custom Tail Painter
class ChatBubbleTail extends CustomPainter {
  final bool isSentByMe;

  ChatBubbleTail(this.isSentByMe);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = isSentByMe ? Colors.green[300]! : Colors.white;

    final path = Path();
    if (isSentByMe) {
      // Outgoing message (tail at bottom-right)
      path.moveTo(10, 0);
      path.lineTo(0, 10);
      path.lineTo(-10, 0);
    } else {
      // Incoming message (tail at bottom-left)
      path.moveTo(-10, 0);
      path.lineTo(0, 10);
      path.lineTo(10, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

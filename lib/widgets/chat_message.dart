import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String uid;
  final String text;
  final AnimationController animationController;

  const ChatMessage({
    super.key,
    required this.uid,
    required this.text,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        child: Container(
          child: uid == '123' ? _createdMessage() : _receivedMessage(),
        ),
      ),
    );
  }

  Widget _createdMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, right: 5, left: 50),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _receivedMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}

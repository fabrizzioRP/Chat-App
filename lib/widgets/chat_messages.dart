import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessages extends StatelessWidget {
  final String message, uid;
  final AnimationController animationController;

  const ChatMessages({
    Key? key,
    required this.message,
    required this.uid,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController, curve: Curves.bounceOut),
        child: Container(
          child: uid == '123'
              ? _MyMessage(texto: message)
              : _FriendMessage(texto: message),
        ),
      ),
    );
  }
}

class _MyMessage extends StatelessWidget {
  final String texto;
  const _MyMessage({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 15,
          left: 50,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.deepOrange.shade400,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(texto),
      ),
    );
  }
}

class _FriendMessage extends StatelessWidget {
  final String texto;
  const _FriendMessage({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          bottom: 15,
          left: 8,
          right: 50,
        ),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade400,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(texto),
      ),
    );
  }
}

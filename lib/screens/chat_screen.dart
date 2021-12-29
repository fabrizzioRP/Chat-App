// ignore_for_file: prefer_is_empty

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  List<ChatMessages> messages = [];

  bool _isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Row(
          children: const [
            CircleAvatar(
              child: Text('FR', style: TextStyle(fontSize: 18)),
              maxRadius: 20,
              backgroundColor: Colors.greenAccent,
            ),
            SizedBox(width: 10),
            Text(
              'Fabrizzio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'videoCam',
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
          IconButton(
            tooltip: 'call',
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            tooltip: 'options',
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) => messages[i],
              ),
            ),
            const Divider(height: 1),
            // todo
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              height: 60,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  SafeArea _inputChat() => SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmit,
                  onChanged: (texto) => setState(() => (texto.trim().length > 0)
                      ? _isTyping = true
                      : _isTyping = false),
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Enviar mensaje',
                  ),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        child: const Text('send'),
                        onPressed: (_isTyping)
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Transform.rotate(
                          angle: 5.8,
                          child: IconTheme(
                            data: const IconThemeData(color: Colors.lightBlue),
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: const Icon(Icons.send),
                              onPressed: (_isTyping)
                                  ? () =>
                                      _handleSubmit(_textController.text.trim())
                                  : null,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );

  _handleSubmit(String texto) {
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessages(
      message: texto,
      uid: '123',
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    if (texto.trim().length > 0) {
      messages.insert(0, newMessage);
      newMessage.animationController.forward();
    }

    setState(() {
      _isTyping = false;
    });
  }

  @override
  void dispose() {
    // OFF del socket.

    for (ChatMessages message in messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}

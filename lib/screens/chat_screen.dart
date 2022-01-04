// ignore_for_file: prefer_is_empty

import 'dart:io';
import 'package:chat_app/models/mensajes.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//
import 'package:provider/provider.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _focusNode = FocusNode();
  final _textController = TextEditingController();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessages> messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String uid) async {
    List<Mensaje> chat = await chatService.getChat(uid);

    final history = chat.map((m) => ChatMessages(
          message: m.mensaje,
          uid: m.de,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessages message = ChatMessages(
      message: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );

    setState(() {
      messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final user = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Row(
          children: [
            Hero(
              tag: '${user.uid} - hero',
              child: CircleAvatar(
                child: Text(user.nombre.substring(0, 2).toUpperCase(),
                    style: const TextStyle(fontSize: 18)),
                maxRadius: 20,
                backgroundColor: Colors.greenAccent,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              user.nombre.toUpperCase(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
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
      body: Column(
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
      uid: authService.usuario.uid,
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

    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto,
    });
  }

  @override
  void dispose() {
    socketService.socket.off('mensaje-personal');

    for (ChatMessages message in messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}

// ignore_for_file: constant_identifier_names, library_prefixes

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
//
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService extends ChangeNotifier {
  final String _url = Environments.socketUrl;

  late IO.Socket _socket;

  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket get socket => _socket;

  ServerStatus get serverStatus => _serverStatus;
  Function get emit => _socket.emit;

  bool _typeConnect = false;

  bool get typeConnect => _typeConnect;

  set typeConnect(bool value) {
    _typeConnect = value;
    notifyListeners();
  }

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client Socket Connection :
    _socket = IO.io(_url, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'Authorization': token}
    });

    _socket.onConnect((_) {
      debugPrint('App connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      debugPrint('App disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
// USANDO SOCKET.IO@2.3.0 version
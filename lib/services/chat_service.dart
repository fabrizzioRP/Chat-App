import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/mensajes.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';

class ChatService extends ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    final url = Uri.parse('${Environments.apiUrl}/mensajes/$usuarioId');

    final token = await AuthService.getToken();

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    });

    final mensajesResp = MensajesResponse.fromJson(resp.body);
    return mensajesResp.mensajes;
  }
}

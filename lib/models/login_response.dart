// To parse this JSON data, do
//
//     final mensajeResponse = mensajeResponseFromMap(jsonString);

import 'dart:convert';

import 'package:chat_app/models/usuario.dart';

class LoginResponse {
  LoginResponse({
    required this.ok,
    required this.msg,
    required this.usuarioDb,
    required this.token,
  });

  bool ok;
  String msg;
  Usuario usuarioDb;
  String token;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        msg: json["msg"],
        usuarioDb: Usuario.fromMap(json["usuarioDB"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "msg": msg,
        "usuarioDB": usuarioDb.toMap(),
        "token": token,
      };
}

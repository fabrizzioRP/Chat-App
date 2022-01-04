import 'dart:convert';

import 'usuario.dart';

class UsuariosListaResponse {
  UsuariosListaResponse({
    required this.ok,
    required this.usuario,
  });

  bool ok;
  List<Usuario> usuario;

  factory UsuariosListaResponse.fromJson(String str) =>
      UsuariosListaResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsuariosListaResponse.fromMap(Map<String, dynamic> json) =>
      UsuariosListaResponse(
        ok: json["ok"],
        usuario:
            List<Usuario>.from(json["usuario"].map((x) => Usuario.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "usuario": List<dynamic>.from(usuario.map((x) => x.toMap())),
      };
}

// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

class Usuario {
  Usuario({
    required this.nombre,
    required this.email,
    required this.online,
    required this.uid,
  });

  String nombre;
  String email;
  bool online;
  String uid;

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
      };
}

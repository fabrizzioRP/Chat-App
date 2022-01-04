// ignore_for_file: import_of_legacy_library_into_null_safe, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';

class AuthService extends ChangeNotifier {
  late Usuario usuario;
  bool _authenticate = false;
  final _storage = const FlutterSecureStorage();

  bool get authenticante => _authenticate;

  set authenticante(bool value) {
    _authenticate = value;
    notifyListeners();
  }

  // Getters del token de forma estatica
  static Future<String> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token') ?? '';
    return token;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
  //

  Future<bool> login(String email, String password) async {
    _authenticate = true;

    final Map<String, String> dataJson = {'email': email, 'password': password};

    final url = Uri.parse('${Environments.apiUrl}/login/');

    final resp = await http.post(url, body: jsonEncode(dataJson), headers: {
      'Content-Type': 'application/json',
    });

    //print(resp.body);
    _authenticate = false;

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);

      usuario = loginResponse.usuarioDb;

      await _saveToken(loginResponse.token);

      return true;
    }

    return false;
  }

  Future register(String nombre, String email, String password) async {
    _authenticate = true;
    final Map<String, String> dataJson = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final url = Uri.parse('${Environments.apiUrl}/login/new');

    final resp = await http.post(url,
        body: jsonEncode(dataJson),
        headers: {'Content-Type': 'application/json'});

    //print(resp.body);
    _authenticate = false;
    if (resp.statusCode == 200) {
      final registerResponse = LoginResponse.fromJson(resp.body);

      await _saveToken(registerResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';

    final url = Uri.parse('${Environments.apiUrl}/login/renew');

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    });

    if (resp.statusCode == 200) {
      final verificatedTokenResponse = LoginResponse.fromJson(resp.body);

      usuario = verificatedTokenResponse.usuarioDb;

      await _saveToken(verificatedTokenResponse.token);

      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _saveToken(String token) async =>
      await _storage.write(key: 'token', value: token);

  Future logout() async => await _storage.delete(key: 'token');
}

import 'package:http/http.dart' as http;
//
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/models/usuarios_response.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final url = Uri.parse('${Environments.apiUrl}/usuarios');
      final token = await AuthService.getToken();

      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      });

      final usuariosResponse = UsuariosListaResponse.fromJson(resp.body);

      return usuariosResponse.usuario;
    } catch (error) {
      return [];
    }
  }
}

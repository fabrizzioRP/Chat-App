// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/usuarios_services.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuariosService = UsuariosService();

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargaUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          usuario.nombre.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
        elevation: 1,
        leading: IconButton(
          tooltip: 'Exit',
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.greenAccent),
          waterDropColor: Colors.blue,
        ),
        onRefresh: _cargaUsuarios,
        child: _listViewUsers(),
      ),
    );
  }

  ListView _listViewUsers() => ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(usuarios[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: usuarios.length,
      );

  ListTile _userListTile(Usuario user) => ListTile(
        title: Text(user.nombre,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
        subtitle: Text(user.email),
        leading: Hero(
          tag: '${user.uid} - hero',
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade300,
            child: Text(user.nombre.substring(0, 2).toUpperCase(),
                style: const TextStyle(fontSize: 18)),
            maxRadius: 25,
          ),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = user;
          Navigator.pushNamed(context, 'chat');
        },
      );

  _cargaUsuarios() async {
    usuarios = await usuariosService.getUsuarios();
    _refreshController.refreshCompleted();
    setState(() {});
  }
}

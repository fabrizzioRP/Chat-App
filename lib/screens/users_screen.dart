// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//
import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/services/auth_service.dart';

class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [
    Usuario(
      uid: '1',
      nombre: 'juan',
      email: 'juan@gmail.com',
      online: true,
    ),
    Usuario(
      uid: '2',
      nombre: 'Veronica',
      email: 'Veronica@gmail.com',
      online: false,
    ),
    Usuario(
      uid: '3',
      nombre: 'Francisca',
      email: 'Francisca@gmail.com',
      online: true,
    ),
    Usuario(
      uid: '4',
      nombre: 'Micaela',
      email: 'Micaela@gmail.com',
      online: false,
    ),
    Usuario(
      uid: '5',
      nombre: 'Agustina',
      email: 'Agustina@gmail.com',
      online: true,
    ),
    Usuario(
      uid: '6',
      nombre: 'Diane',
      email: 'Diane@gmail.com',
      online: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          usuario.nombre,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        elevation: 1,
        leading: IconButton(
          tooltip: 'Exit',
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            //child: Icon(Icons.check_circle, color: Colors.green),
            child: const Icon(Icons.offline_bolt, color: Colors.red),
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
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade300,
          child: Text(user.nombre.substring(0, 2),
              style: const TextStyle(fontSize: 18)),
          maxRadius: 25,
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      );

  _cargaUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

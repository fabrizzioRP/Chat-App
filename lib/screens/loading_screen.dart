// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
import 'package:chat_app/screens/screens.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: FutureBuilder(
          future: checkLoginState(context),
          builder: (context, snapshot) => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      );

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      socketService.connect();
      navigatePage(context, UsersScreen());
    } else {
      navigatePage(context, LoginScreen());
    }
  }

  navigatePage(BuildContext context, Widget screen) =>
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (_, __, ___) => screen,
        ),
      );
}

import 'package:chat_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
import 'package:chat_app/services/auth_service.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) => const Center(
          child: Text('Bienvenido :)'),
        ),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      // conectar al socket server
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (_, __, ___) => UsersScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 0),
          pageBuilder: (_, __, ___) => const LoginScreen(),
        ),
      );
    }
  }
}

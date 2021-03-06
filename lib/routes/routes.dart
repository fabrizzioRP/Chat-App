import 'package:flutter/material.dart';
import 'package:chat_app/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsersScreen(),
  'chat': (_) => const ChatScreen(),
  'login': (_) => LoginScreen(),
  'register': (_) => const RegisterScreen(),
  'loading': (_) => LoadingScreen(),
};

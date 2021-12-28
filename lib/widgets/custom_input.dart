import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String texto;
  final IconData icon;
  final bool isPassword;
  final TextInputType textInput;
  final TextEditingController textController;

  const CustomInput({
    Key? key,
    required this.texto,
    required this.icon,
    required this.isPassword,
    required this.textController,
    required this.textInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        autocorrect: false,
        keyboardType: textInput,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: texto,
          hintStyle: const TextStyle(color: Colors.black38),
        ),
      ),
    );
  }
}

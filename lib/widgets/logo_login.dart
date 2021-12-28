// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoLogin extends StatelessWidget {
  final String titulo;
  final String image;
  final bool isNotSvg;

  const LogoLogin(
      {required this.titulo, required this.image, required this.isNotSvg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 50),
          if (isNotSvg) Image(image: AssetImage(image), width: 160),
          if (!isNotSvg) SvgPicture.asset(image, height: 180),
          const SizedBox(height: 20),
          Text(titulo,
              style:
                  const TextStyle(fontSize: 30, fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }
}

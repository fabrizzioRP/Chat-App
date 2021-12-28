import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String texto, texto2;

  const Labels(
      {Key? key, required this.ruta, required this.texto, required this.texto2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            texto,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => Navigator.pushReplacementNamed(context, ruta),
            child: Text(
              texto2,
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

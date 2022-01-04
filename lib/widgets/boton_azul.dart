import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final double? width, height;
  final VoidCallback? send;

  const BotonAzul({
    Key? key,
    required this.text,
    required this.send,
    this.height = 55,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 17)),
        ),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(2.0),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        //backgroundColor: MaterialStateProperty.all(backColor),
      ),
      onPressed: send,
    );
  }
}

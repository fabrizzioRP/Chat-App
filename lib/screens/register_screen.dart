// ignore_for_file: sized_box_for_whitespace

import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: size.height * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                LogoLogin(
                  titulo: 'Register',
                  image: 'assets/register.svg',
                  isNotSvg: false,
                ),
                _Form(),
                Labels(
                    ruta: 'login',
                    texto: '¿ Ya tienes Cuenta ?',
                    texto2: 'Ingrese Aqui'),
                Text('Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final consumeProvider = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            texto: 'Name',
            isPassword: false,
            textController: nameCtrl,
            textInput: TextInputType.text,
          ),
          const SizedBox(height: 20),
          CustomInput(
            icon: Icons.email_outlined,
            texto: 'Email',
            isPassword: false,
            textController: emailCtrl,
            textInput: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          CustomInput(
            icon: Icons.lock_outline,
            texto: 'Password',
            isPassword: true,
            textController: passCtrl,
            textInput: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 35),
          BotonAzul(
            text: 'Register',
            send: (consumeProvider.authenticante)
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final registerOk = await consumeProvider.register(
                      nameCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );

                    if (registerOk == true) {
                      Navigator.pushReplacementNamed(context, 'login');
                    } else {
                      showAlert(context, 'Registro Incorrecto', registerOk);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

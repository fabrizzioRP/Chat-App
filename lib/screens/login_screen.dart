import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: const Color(0xffF2F2F2),
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
                    titulo: 'Messenger',
                    image: 'assets/tag-logo.png',
                    isNotSvg: true),
                _Form(),
                Labels(
                  ruta: 'register',
                  texto: '¿ No tienes una Cuenta ?',
                  texto2: 'Crea una ahora!',
                ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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
            text: 'Ingresar',
            backColor: Colors.blue,
            send: () {
              FocusScope.of(context).requestFocus(FocusNode());
              print(emailCtrl.text);
              print(passCtrl.text);
            },
          ),
        ],
      ),
    );
  }
}

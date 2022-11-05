import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/widgets/blue_button.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(title: 'Messenger'),
                _Form(),
                const Labels(
                  route: 'register',
                  title: 'No account yet?',
                  subTitle: 'Create account!',
                ),
                const Text(
                  'Terms and Conditions',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            iconData: Icons.mail_outline,
            placeHolder: 'Email',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            iconData: Icons.lock_outline,
            placeHolder: 'Password',
            textController: passwordController,
            isPassword: true,
          ),
          BlueButton(
            butttonText: 'Log In',
            onPressed: authService.isAuthenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final isAuth = await authService.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (!mounted) return;
                    if (isAuth) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(context, 'Login Failed', 'Invalid Credentials');
                    }
                  },
          )
        ],
      ),
    );
  }
}

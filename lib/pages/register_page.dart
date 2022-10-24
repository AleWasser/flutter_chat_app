import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/widgets/blue_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
                const Logo(title: 'Register'),
                _Form(),
                const Labels(
                  route: 'login',
                  title: 'Already have an account?',
                  subTitle: 'Log in to your account!',
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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            iconData: Icons.perm_identity_outlined,
            placeHolder: 'Name',
            textController: nameController,
          ),
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
            butttonText: 'Create Account',
            onPressed: authService.isAuthenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final isAuth = await authService.register(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (!mounted) return;
                    if (isAuth == true) {
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showAlert(
                        context,
                        'Registration Failed',
                        isAuth,
                      );
                    }
                  },
          )
        ],
      ),
    );
  }
}

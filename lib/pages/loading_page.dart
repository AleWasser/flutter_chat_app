import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return const Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context, [bool mounted = true]) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticated = await authService.isLoggedIn();

    if (!mounted) return;
    if (authenticated) {
      return Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: ((_, __, ___) => UsersPage()),
          transitionDuration: const Duration(milliseconds: 0),
        ),
      );
    }
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: ((_, __, ___) => const LoginPage()),
        transitionDuration: const Duration(milliseconds: 0),
      ),
    );
  }
}

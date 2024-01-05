import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:new_flutter/constants/routes.dart';
import 'package:new_flutter/services/auth/auth_exception.dart';
import 'package:new_flutter/services/auth/auth_services.dart';

import '../utilities/show_error_dialouge.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    super.initState();
    _password = TextEditingController();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                enableSuggestions: false,
                autocorrect: false,
                controller: _email,
                decoration:
                    const InputDecoration(hintText: 'Enter Your Email here'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Enter Your Password here'),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      // await userCredential =

                      AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );

                      final user = AuthService.firebase().currentUser;

                      if (user?.isEmailVerified ?? false) {
                        // user's email is verified
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoutes, (route) => false);
                      } else {
                        // user's email is not verified
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute, (route) => false);
                      }
                    } on UserNotFoundAuthException catch (e) {
                      await showErrorDialog(
                        context,
                        "User not Found",
                      );
                    } on WronPasswordAuthException catch (e) {
                      await showErrorDialog(
                        context,
                        "Wrong passcode",
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        "Error ${"Authentication Error"}",
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoutes, (route) => false);
                  },
                  child: const Text('Not Registered yet ? Register here'))
            ],
          ),
        ));
  }
}

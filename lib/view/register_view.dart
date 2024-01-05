// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/constants/routes.dart';
import 'package:new_flutter/services/auth/auth_exception.dart';
import 'package:new_flutter/utilities/show_error_dialouge.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';
import '../services/auth/auth_services.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          title: const Text(' Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: AuthService.firebase().initialize(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _email,
                        decoration: const InputDecoration(
                            hintText: 'Enter Your Email here'),
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                            hintText: 'Enter Your Password here'),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;

                            try {
                              AuthService.firebase().createUser(
                                email: email,
                                password: password,
                              );

                              AuthService.firebase().sendEmailVerification();
                              final user = AuthService.firebase().currentUser;

                              Navigator.of(context).pushNamed(verifyEmailRoute);
                            } on WeakPasswordAuthException catch (e) {
                              await showErrorDialog(
                                context,
                                'weak password',
                              );
                            } on EmailAlreadyInUseAuthException catch (e) {
                              await showErrorDialog(
                                context,
                                'Email Already In Use ',
                              );
                            } on InvalidEmailAuthException catch (e) {
                              await showErrorDialog(
                                context,
                                'Invalid Email',
                              );
                            } on GenericAuthException catch (e) {
                              await showErrorDialog(
                                context,
                                'Failed to Register',
                              );
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoutes, (route) => false);
                          },
                          child: const Text('Already Registered ? Login here!'))
                    ],
                  );

                default:
                  return Text('Loading');
              }
            },
          ),
        ));
  }
}

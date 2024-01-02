import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
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
                              final userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);

                              print("userCredential${userCredential}");
                            } on FirebaseAuthException catch (e) {
                              print(e.code);
                              if (e.code == 'weak-password') {
                                print('weak password');
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.cyan,
                                  content: Text(e.code.toString()),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login/', (route) => false);
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

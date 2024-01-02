import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_options.dart';

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
                      final userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);

                      print("userCredential${userCredential}");
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      if (e.code == 'user-not-found') {
                        print("User not Found");
                        const snackBar = SnackBar(
                          backgroundColor: Colors.cyan,
                          content: Text("User not Found"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (e.code == 'wrong-password') {
                        print("Wrong passcode");
                        const snackBar = SnackBar(
                          backgroundColor: Colors.cyan,
                          content: Text("Wrong password"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } catch (e) {
                      print(e);
                      print("runtime${e.runtimeType}");
                      final snackBar = SnackBar(
                        backgroundColor: Colors.cyan,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/register/', (route) => false);
                  },
                  child: const Text('Not Registered yet ? Register here'))
            ],
          ),
        ));
  }
}

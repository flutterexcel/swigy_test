import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My Test App',
    theme: ThemeData(primarySwatch: Colors.cyan),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

                            final userCredential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);

                            print("userCredential${userCredential}");
                          },
                          child: const Text('Register'),
                        ),
                      ),
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







// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       home: const MyHomePage(title: 'Swiggy Dynamic Page'),
//     );
//   }
// } 

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body:
//           // Center is a layout widget. It takes a single child and positions it
//           // in the middle of the parent.
//           Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Spacer(),
//         Divider(color: Colors.grey),
//       ]),

//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return HoverItem();
//                     },
//                   );
//                 },
//                 onHover: (value) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return const HoverItem();
//                     },
//                   );
//                 },
//                 child: Container(
//                   height: 30,
//                   width: 30,
//                   child: Image(
//                       image: AssetImage('asset/images/swiggy.176x256.png')),
//                 ),
//               ),
//             ),

//             Expanded(
//               child: Container(
//                 height: 30,
//                 width: 30,
//                 child: Image(image: AssetImage('asset/images/swiggybowl.png')),
//               ),
//             ),

//             Expanded(
//               child: Container(
//                 height: 30,
//                 width: 30,
//                 child:
//                     Image(image: AssetImage('asset/images/swiggy_grocery.png')),
//               ),
//             ),

//             Expanded(
//               child: Container(
//                 height: 30,
//                 width: 30,
//                 child: Image(image: AssetImage('asset/images/dineeeee.png')),
//               ),
//             ),

//             Expanded(
//               child: Container(
//                 height: 30,
//                 width: 30,
//                 child: Image(image: AssetImage('asset/images/creditcard.png')),
//               ),
//             ),

//             // Image.asset('apg.png')
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

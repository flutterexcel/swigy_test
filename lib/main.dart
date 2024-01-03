import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/constants/routes.dart';
import 'package:new_flutter/view/login_view.dart';
import 'package:new_flutter/view/register_view.dart';
import 'package:new_flutter/view/verify_email_view.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'My Test App',
    theme: ThemeData(primarySwatch: Colors.cyan),
    home: const HomePage(),
    routes: {
      loginRoutes: (context) => const LoginView(),
      registerRoutes: (context) => const RegisterView(),
      notesRoutes: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                // print("Email is verified");
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          // return const Text("Done");

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction {
  logout,
  nulll,
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Ui"), actions: [
        PopupMenuButton<MenuAction>(
          itemBuilder: (context) {
            return const [
              PopupMenuItem(value: MenuAction.logout, child: Text('Logout'))
            ];
          },
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                devtools.log(shouldLogout.toString());
                if (shouldLogout ?? false) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoutes, (_) => false);
                }
                break;
            }
          },
        )
      ]),
    );
  }
}

Future<bool?> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are You Sure You Want To Sign Out'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout')),
        ],
      );
    },
  ).then((value) => value ?? false);
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

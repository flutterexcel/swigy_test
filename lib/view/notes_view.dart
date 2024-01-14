import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_flutter/constants/routes.dart';
import 'package:new_flutter/services/auth/auth_services.dart';
import 'package:new_flutter/services/crud/notes_services.dart';
import 'dart:developer' as devtools show log;
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String? get userEmail => AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    super.initState();
    _notesService = NotesService();

    _notesService.open();
  }

  @override
  void dispose() {
    super.dispose();
    _notesService.close();
  }

  @override
  Widget build(BuildContext context) {
    log("Email is verified11");
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
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoutes, (_) => false);
                }
                break;
              case MenuAction.nulll:
                // TODO: Handle this case.
                break;
            }
          },
        )
      ]),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail ?? ''),
        builder: (BuildContext context, AsyncSnapshot<DataBaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return const Text('Your Notes will appear here');

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
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

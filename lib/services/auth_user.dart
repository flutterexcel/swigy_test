import 'package:firebase_auth/firebase_auth.dart' as FireBaseAuth show User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  AuthUser(this.isEmailVerified);
  final bool isEmailVerified;

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}

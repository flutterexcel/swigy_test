import 'package:firebase_auth/firebase_auth.dart' as FireBaseAuth show User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser({required this.email, required this.isEmailVerified,});
  final bool isEmailVerified;
  final String ?email;
  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified, email: user.email);
}

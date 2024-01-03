import 'package:new_flutter/services/auth_user.dart';

abstract class Authprovider {
  AuthUser? get CurrentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
}

import 'package:new_flutter/services/auth/auth_provider.dart';
import 'package:new_flutter/services/auth/auth_user.dart';

class AuthService implements Authprovider {
  final Authprovider provider;

  const AuthService(this.provider);

  @override
  // TODO: implement CurrentUser
  AuthUser? get CurrentUser => throw UnimplementedError();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }
}

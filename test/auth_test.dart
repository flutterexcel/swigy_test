import 'package:flutter_test/flutter_test.dart';
import 'package:new_flutter/services/auth/auth_exception.dart';
import 'package:new_flutter/services/auth/auth_provider.dart';
import 'package:new_flutter/services/auth/auth_user.dart';
import 'package:test/test.dart' as testh;

void main() {
  group('Mock Authentication', (() {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider._isInitialized, false);
    });
    test(
      "can not log out if not initialised ",
      () {
        expect(provider.logOut(),
            throwsA(const TypeMatcher<NotInitializedException>()));
      },
    );

    test(
      'should be able to initialize',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
    );

    test(
      'User should be null after initialization',
      () {
        expect(provider.currentUser, null);
      },
    );

    test(
      'should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(const Duration(seconds: 2)),
    );

    test(
      'create user should delegate to login function ',
      () async {
        final badEmailUser = provider.createUser(
          email: 'medhavi11041998@gmail.com',
          password: 'qwertydd',
        );

        expect(badEmailUser,
            throwsA(const TypeMatcher<UserNotFoundAuthException>()));

        final badPasswordUser = provider.createUser(
            email: 'medhavi11041998@gmail.com', password: 'anything');

        expect(badPasswordUser,
            throwsA(const TypeMatcher<WronPasswordAuthException>()));

        final user = provider.createUser(email: 'gg', password: 'kk');

        expect(provider.currentUser, user);
        // expect(user.isEmailVerified, false);
      },
    );
  }));
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements Authprovider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException;
    await Future.delayed(const Duration(seconds: 2));

    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException;
    if (email == 'medhavi11041998@gmail.com') throw UserNotFoundAuthException();
    if (password == 'qwerty') throw WronPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException;
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));

    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException;
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}

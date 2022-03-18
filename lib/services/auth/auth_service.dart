import 'package:homepay/services/auth/auth_provider.dart';
import 'package:homepay/services/auth/auth_user.dart';
import 'package:homepay/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createuser({required email, required password}) =>
      provider.createuser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required email, required password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}

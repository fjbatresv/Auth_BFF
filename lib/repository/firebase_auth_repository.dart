import 'package:firebase_auth/firebase_auth.dart';
import 'package:speak_bff/repository/firebase_auth_api.dart';

class FirebaseAuthRepository {
  final FirebaseAuthApi _authApi = FirebaseAuthApi();

  Stream<FirebaseUser> authStatus() => _authApi.authStatus();

  Future<FirebaseUser> googleSignin() => _authApi.googleSignin();

  Future<FirebaseUser> emailSignin(email, password) => _authApi.emailSignin(email, password);

  Future<FirebaseUser> emailSignup(email, password) => _authApi.emailSignup(email, password);

  Future<FirebaseUser> currentUser() => _authApi.currentUser();

  Future<dynamic> recoverPassword(email) => _authApi.recoverPassword(email);

  Future<void>signOut() => _authApi.signOut();

}
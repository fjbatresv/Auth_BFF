import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:speak_bff/repository/firebase_auth_repository.dart';

class AuthBloc extends Bloc {

  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();

  Stream<FirebaseUser> get authStatus => _authRepository.authStatus();

  Future<FirebaseUser> googleSignin() => _authRepository.googleSignin();

  Future<FirebaseUser> emailSignin(email, password) => _authRepository.emailSignin(email, password);

  Future<FirebaseUser> emailSignup(email, password) => _authRepository.emailSignup(email, password);

  Future<FirebaseUser> currentUser() => _authRepository.currentUser();

  Future<dynamic> recoverPassword(email) => _authRepository.recoverPassword(email);

  Future<void>signOut() => _authRepository.signOut();

  @override
  void dispose() {
  }
}
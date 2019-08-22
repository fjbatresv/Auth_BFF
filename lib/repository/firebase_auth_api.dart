import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = GoogleSignIn();

  Stream<FirebaseUser> authStatus() {
    return _auth.onAuthStateChanged;
  }

  Future<FirebaseUser> currentUser() async {
    return await _auth.currentUser();
  }

  Future<FirebaseUser> googleSignin() async {
    await signOut();
    GoogleSignInAccount gAccount = await _gSignIn.signIn();
    if (gAccount == null) return null;
    GoogleSignInAuthentication gAuth = await gAccount.authentication;
    AuthResult result = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
            idToken: gAuth.idToken, accessToken: gAuth.accessToken));
    return result.user;
  }

  Future<FirebaseUser> emailSignin(email, password) async {
    await signOut();
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<FirebaseUser> emailSignup(email, password) async {
    await signOut();
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (result.user != null) {
      result.user.sendEmailVerification();
    }
    return result.user;
  }

  Future<dynamic> recoverPassword(email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    FirebaseUser user = await this.currentUser();
    if (user != null && user.providerId == GoogleAuthProvider.providerId) {
      await _gSignIn.signOut();
    }
    await _auth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:runconnect/models/app_user.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sing up a new user
  static Future<AppUser?> signUpUser(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return AppUser(
            email: userCredential.user!.email!, uid: userCredential.user!.uid);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // sign out a user
  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // sign in a user
  static Future<AppUser?> signInUser(String email, String password) async {
    try {
      final UserCredential credentials = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credentials.user != null) {
        return AppUser(
            email: credentials.user!.email!, uid: credentials.user!.uid);
      }
      return null; // if there's an error
    } catch (e) {
      return null;
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runconnect/models/app_user.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sing up a new user
  static Future<Either<AppUser?, String>> signUpUser(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        return Left(AppUser(
            email: userCredential.user!.email!, uid: userCredential.user!.uid));
      }
      return const Right('Unknown error occured.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Handle the case when the email is already in use
        return const Right('Email already exists. Try signing in instead.');
      } else {
        // Handle other errors
        return Right('Error: ${e.message}');
      }
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

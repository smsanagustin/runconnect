import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/services/firestore_service.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // sign up a new user
  static Future<Either<AppUser?, String>> signUpUser(
      String email, String password, String username) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create a new AppUser instance if account is created successfully
      if (userCredential.user != null) {
        AppUser appUser = AppUser(
            email: userCredential.user!.email!,
            uid: userCredential.user!.uid,
            username: username);
        // add to firestore
        FirestoreService.addUser(appUser);

        // update global state

        return Left(appUser);
      }

      return const Right('Unknown error occured.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return const Right('Email already exists. Try signing in instead.');
      } else {
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
            email: credentials.user!.email!,
            uid: credentials.user!.uid,
            username: "placeholder value for now");
      }
      return null; // if there's an error
    } catch (e) {
      return null;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/models/app_user.dart';

// watch for auth state changes (user logs in or signs in)
final authProvider = StreamProvider.autoDispose<AppUser?>((ref) async* {
  final Stream<AppUser?> userStream =
      FirebaseAuth.instance.authStateChanges().map((user) {
    if (user != null) {
      // TODO: instead of creating a new instance of AppUser, go to Firestore and select the
      // existing AppUser and return that instead.
      return AppUser(
          email: user.email!, uid: user.uid, username: "Placeholder for now");
    }
    return null;
  });

  // yield value whenever a user logs or signs in
  await for (final user in userStream) {
    yield user;
  }
});

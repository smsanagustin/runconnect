// firestore_service
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runconnect/models/app_user.dart';

class FirestoreService {
  // add a reference to the characters collection
  static final ref = FirebaseFirestore.instance
      .collection("appUsers")
      .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser a, _) => a.toFirestore());

  // add user to firestore
  static Future<void> addUser(AppUser appUser) async {
    await ref.doc(appUser.uid).set(appUser);
  }

  // get a user after they've signed in or signed up
  static Future<AppUser?> getUser(String uid) async {
    final doc = await ref.doc(uid).get();
    return doc.data();
  }

  // update user's profile in firestore
  static Future<void> updateUser(AppUser appUser) async {
    await ref.doc(appUser.uid).update({
      'fullName': appUser.fullName,
      'username': appUser.username,
      'location': appUser.location
    });
  }
}

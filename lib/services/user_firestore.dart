// firestore_service
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runconnect/models/app_user.dart';

class UserFirestoreService {
  // add a reference to the users collection
  static final userRef = FirebaseFirestore.instance
      .collection("appUsers")
      .withConverter(
          fromFirestore: AppUser.fromFirestore,
          toFirestore: (AppUser a, _) => a.toFirestore());

  // USER METHODS
  // add user to firestore
  static Future<void> addUser(AppUser appUser) async {
    await userRef.doc(appUser.uid).set(appUser);
  }

  // get a user
  static Future<AppUser?> getUser(String uid) async {
    final doc = await userRef.doc(uid).get();
    return doc.data();
  }

  // update user's profile in firestore
  static Future<void> updateUser(AppUser appUser) async {
    await userRef.doc(appUser.uid).update({
      'fullName': appUser.fullName,
      'username': appUser.username,
      'location': appUser.location,
      'idsOfFollowing': appUser.idsOfFollowing,
      'idsOfFollowers': appUser.idsOfFollowers,
      'createdEventIds': appUser.createdEventIds,
      'joinedEventIds': appUser.joinedEventIds,
      'bookmarkedEventIds': appUser.bookmarkedEventIds
    });
  }

  // RUN EVENT METHODS
  // add an event to firestore
}

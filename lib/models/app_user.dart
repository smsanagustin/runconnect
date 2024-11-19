import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.email,
    required this.uid,
    this.username = "",
    this.fullName = "",
    this.profilePhoto = "",
    this.location = "",
    List<String>? idsOfFollowing,
    List<String>? idsOfFollowers,
    List<String>? createdEventIds,
    List<String>? joinedEventIds,
    List<String>? bookmarkedEventIds,
  })  : _idsOfFollowing = idsOfFollowing ?? [],
        _idsOfFollowers = idsOfFollowers ?? [],
        _createdEventIds = createdEventIds ?? [],
        _joinedEventIds = joinedEventIds ?? [],
        _bookmarkedEventIds = bookmarkedEventIds ?? [];

  // fields
  final String email;
  final String uid;
  String username;
  String fullName;
  String location;
  String profilePhoto; // URL
  List<String> _idsOfFollowing;
  List<String> _idsOfFollowers;
  List<String> _createdEventIds;
  List<String> _joinedEventIds;
  List<String> _bookmarkedEventIds;

  // getters
  List<String> get idsOfFollowing => List.unmodifiable(_idsOfFollowing);
  List<String> get idsOfFollowers => List.unmodifiable(_idsOfFollowers);
  List<String> get createdEventIds => List.unmodifiable(_createdEventIds);
  List<String> get joinedEventIds => List.unmodifiable(_joinedEventIds);
  List<String> get bookmarkedEventIds => List.unmodifiable(_bookmarkedEventIds);

  // methods
  void addCreatedEventId(String eventId) {
    _createdEventIds.add(eventId);
  }

  void addJoinedEventId(String eventId) {
    _joinedEventIds.add(eventId);
  }

  void addBookmarkedEventId(String eventId) {
    _bookmarkedEventIds.add(eventId);
  }

  void addFollowerId(String eventId) {
    _idsOfFollowers.add(eventId);
  }

  void addFollowingId(String eventId) {
    _idsOfFollowing.add(eventId);
  }

  void removeCreatedEventId(String eventId) {
    _createdEventIds.remove(eventId);
  }

  void removeJoinedEventId(String eventId) {
    _joinedEventIds.remove(eventId);
  }

  void removeBookmarkedEventId(String eventId) {
    _bookmarkedEventIds.remove(eventId);
  }

  // method to send object's data to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'location': location,
      'profilePhoto': profilePhoto,
      'idsOfFollowing': idsOfFollowing,
      'idsOfFollowers': idsOfFollowers,
      'createdEventIds': createdEventIds,
      'joinedEventIds': joinedEventIds,
      'bookmarkedEventIds': bookmarkedEventIds,
    };
  }

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;

    // make an app user instance
    AppUser appUser = AppUser(
      email: data['email'],
      uid: data['uid'],
      username: data['username'],
      fullName: data['fullName'],
      profilePhoto: data['profilePhoto'],
    );

    // get list of created events
    for (String eventId in data['createdEventIds']) {
      appUser.addCreatedEventId(eventId);
    }

    // get list of joined events
    for (String eventId in data['joinedEventIds']) {
      appUser.addJoinedEventId(eventId);
    }

    // get list of bookmarked events
    for (String eventId in data['bookmarkedEventIds']) {
      appUser.addBookmarkedEventId(eventId);
    }

    return appUser;
  }
}

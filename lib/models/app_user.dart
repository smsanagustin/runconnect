class AppUser {
  AppUser({
    required this.email,
    required this.uid,
    required this.username,
    this.fullName = "",
    this.profilePhoto = "",
    this.createdEventIds = const [],
    this.joinedEventIds = const [],
    this.bookmarkedEventIds = const [],
  });

  final String email;
  final String uid;
  String username;
  String fullName;
  String profilePhoto; // URL

  // run events created, joined and saved by the user
  List<String> createdEventIds;
  List<String> joinedEventIds;
  List<String> bookmarkedEventIds;

  // method to send object's data to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'profilePhoto': profilePhoto,
      'createdEventIds': createdEventIds,
      'joinedEventIds': joinedEventIds
    };
  }
}

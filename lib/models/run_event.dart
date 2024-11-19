import 'package:cloud_firestore/cloud_firestore.dart';

class RunEvent {
  // constructor
  RunEvent({
    required this.id,
    required this.title,
    required this.location,
    required this.meetupPlace,
    required this.time,
    required this.distance,
    required this.numberOfParticipants,
    required this.date,
    required this.runType,
    List<String>? comments,
  }) : _comments = comments ?? [];

  String? id;
  String? title;
  String? location;
  String? meetupPlace;
  String? time;
  int? distance;
  int? numberOfParticipants;
  String? date;
  String? runType;
  List<String> _comments;

  // getter for a comment
  List<String> get comments => List.unmodifiable(_comments);

  // add a comment to this event
  void addComment(String commentId) {
    _comments.add(commentId);
  }

  // method to send object's data to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'meetupPlace': meetupPlace,
      'time': time,
      'distance': distance,
      'numberOfParticipants': numberOfParticipants,
      'date': date,
      'runType': runType,
      'comments': comments,
    };
  }

  // method to convert a received data from firestore to a RunEvent object
  factory RunEvent.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;

    // make a RunEvent instance
    RunEvent runEvent = RunEvent(
        id: data['id'],
        title: data['title'],
        location: data['location'],
        meetupPlace: data['meetupPlace'],
        time: data['time'],
        distance: data['distance'],
        numberOfParticipants: data['numberOfParticipants'],
        date: data['date'],
        runType: data['runType']);

    // get list of comments
    for (String commentId in data['comments']) {
      runEvent.addComment(commentId);
    }

    return runEvent;
  }
}

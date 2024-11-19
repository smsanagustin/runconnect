import 'package:cloud_firestore/cloud_firestore.dart';

class RunEvent {
  // constructor
  RunEvent({
    required this.id,
    required this.creatorId,
    required this.title,
    required this.location,
    required this.meetupPlace,
    required this.time,
    required this.distance,
    required this.numberOfParticipants,
    required this.date,
    required this.runType,
    required this.visibility,
    List<String>? comments,
    List<String>? participants,
  })  : _comments = comments ?? [],
        _participants = participants ?? [];

  String? id;
  String? creatorId;
  String? title;
  String? location;
  String? meetupPlace;
  String? time;
  String? date;
  String? runType;
  String? visibility;
  int? distance;
  int? numberOfParticipants;
  List<String> _comments;
  List<String> _participants; // ids of the people who joined the run

  // getterrs
  List<String> get comments => List.unmodifiable(_comments);
  List<String> get participants => List.unmodifiable(_participants);

  // add a comment to this event
  void addComment(String commentId) {
    _comments.add(commentId);
  }

  // add a comment to this event
  void addParticipant(String participantId) {
    _participants.add(participantId);
  }

  // method to send object's data to firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'creatorId': creatorId,
      'title': title,
      'location': location,
      'meetupPlace': meetupPlace,
      'time': time,
      'distance': distance,
      'numberOfParticipants': numberOfParticipants,
      'date': date,
      'runType': runType,
      'visibility': visibility,
      'comments': comments,
      'participants': participants
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
        creatorId: data['creatorId'],
        title: data['title'],
        location: data['location'],
        meetupPlace: data['meetupPlace'],
        time: data['time'],
        distance: data['distance'],
        numberOfParticipants: data['numberOfParticipants'],
        date: data['date'],
        runType: data['runType'],
        visibility: data['visibility']);

    // get list of comments
    for (String commentId in data['comments']) {
      runEvent.addComment(commentId);
    }

    // get list of particpants
    for (String participantId in data['participants']) {
      runEvent.addParticipant(participantId);
    }

    return runEvent;
  }
}

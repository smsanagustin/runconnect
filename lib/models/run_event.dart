import 'package:runconnect/models/comment.dart';

class RunEvent {
  String? id;
  String? name;
  String? location;
  String? meetupPlace;
  String? time;
  int? distance;
  String? date;
  String? runType;
  List<Comment> comments;

  // constructor
  RunEvent({
    required this.id,
    required this.name,
    required this.location,
    required this.meetupPlace,
    required this.time,
    required this.distance,
    required this.date,
    required this.runType,
    this.comments = const [],
  });
}

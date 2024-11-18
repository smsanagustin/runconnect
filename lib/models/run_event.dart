import 'package:runconnect/models/comment.dart';

class RunEvent {
  String? name;
  String? location;
  String? meetupPlace;
  String? time;
  int? distance;
  String? date;
  List<Comment> comments;

  // constructor
  RunEvent({
    required this.name,
    required this.location,
    required this.meetupPlace,
    required this.time,
    required this.distance,
    required this.date,
    this.comments = const [],
  });
}

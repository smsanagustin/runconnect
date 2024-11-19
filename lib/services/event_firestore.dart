import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:runconnect/models/run_event.dart';

class EventFirestoreService {
// converters for runevent
  static final eventRef = FirebaseFirestore.instance
      .collection("runEvents")
      .withConverter(
          fromFirestore: RunEvent.fromFirestore,
          toFirestore: (RunEvent e, _) => e.toFirestore());

  // add a new event
  static Future<void> addEvent(RunEvent runEvent) async {
    await eventRef.doc(runEvent.id).set(runEvent);
  }

  // get event details
  static Future<RunEvent?> getEvent(String eventId) async {
    final doc = await eventRef.doc(eventId).get(); // runs fromFirestore()
    return doc.data();
  }

  // update an event
  static Future<void> updateEvent(RunEvent runEvent) async {
    await eventRef.doc(runEvent.id).update({
      'meetupPlace': runEvent.meetupPlace,
      'participants': runEvent.participants,
      'comments': runEvent.comments
    });
  }

  // delete an event
  static Future<void> deleteEvent(RunEvent runEvent) async {
    await eventRef.doc(runEvent.id).delete();
  }
}

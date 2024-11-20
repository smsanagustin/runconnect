import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:runconnect/models/run_event.dart';
import 'package:runconnect/services/event_firestore.dart';

part 'runs_provider.g.dart';

@riverpod
class RunsNotifier extends _$RunsNotifier {
  @override
  List<RunEvent> build() {
    return const [];
  }

  // get all events
  void getAllEvents() async {
    final snapshot = await EventFirestoreService.getEvents();
    for (var doc in snapshot.docs) {
      state = [...state, doc.data()];
    }
  }
}

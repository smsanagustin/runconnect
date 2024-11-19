// converters for runevent
  static final eventRef = FirebaseFirestore.instance
      .collection("runEvent")
      .withConverter(
          fromFirestore: RunEvent.fromFirestore,
          toFirestore: (RunEvent e, _) => e.toFirestore());

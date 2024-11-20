import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/screens/feed/run_event_container.dart';
import 'package:runconnect/services/event_firestore.dart';
import 'package:runconnect/shared/styled_text.dart';

class UserRuns extends ConsumerStatefulWidget {
  const UserRuns({super.key});

  @override
  ConsumerState<UserRuns> createState() => _UserRunsState();
}

class _UserRunsState extends ConsumerState<UserRuns> {
  @override
  Widget build(BuildContext context) {
    final appUserSet = ref.watch(profileNotifierProvider);
    AppUser? user;

    if (appUserSet.isNotEmpty) {
      user = appUserSet.first;
    }

    if (user != null && user.createdEventIds.isNotEmpty) {
      return Expanded(
          child: ListView.builder(
              itemCount: user.createdEventIds.length,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    FutureBuilder(
                        future: EventFirestoreService.getEvent(
                            user!.createdEventIds[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const StyledText("There's an error.");
                          } else if (snapshot.hasData) {
                            return Column(
                              children: [
                                RunEventContainer(runEvent: snapshot.data!),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          } else {
                            return const StyledText("");
                          }
                        })
                  ],
                );
              }));
    } else {
      return const StyledText("You haven't hosted any runs yet.");
    }
  }
}

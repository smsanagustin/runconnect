import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/models/run_event.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/screens/feed/run_event_container.dart';
import 'package:runconnect/services/event_firestore.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  // @override
  // void initState() {
  //   ref.read(runsNotifierProvider.notifier).getAllEvents();
  //
  //   super.initState();
  // }
  //
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appUser = ref.watch(profileNotifierProvider);
    // final runEvents = ref.watch(runsNotifierProvider);

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title: appUser.isNotEmpty
              ? Row(
                  children: [
                    Image.network(
                      "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/cfca3f83-9e45-4fa4-a361-574cc7aa62f8/dfqkx8j-0297b5f2-4a39-46a9-b12c-2f6ce4d89ca4.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2NmY2EzZjgzLTllNDUtNGZhNC1hMzYxLTU3NGNjN2FhNjJmOFwvZGZxa3g4ai0wMjk3YjVmMi00YTM5LTQ2YTktYjEyYy0yZjZjZTRkODljYTQucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.qNOTax2dCrRMjEWbQFCykaUQqQJbhGdZ3qen285UHp4",
                      height: 40,
                      loadingBuilder: (BuildContext context,
                          Widget
                              child, // ref: https://stackoverflow.com/questions/53577962/better-way-to-load-images-from-network-flutter
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Icon(Icons.image);
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    StyledTitleMedium("Hi, ${appUser.first.username}!"),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.directions_run),
                          appUser.isNotEmpty
                              ? StyledTitleMedium(
                                  "Runs near ${appUser.first.location.split(',').first}") // show only the locality
                              : const StyledTitleMedium("Runs near you"),
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.add_location_alt))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                StreamBuilder(
                    stream: EventFirestoreService.getEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No events available'));
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            RunEvent event = snapshot.data!.docs[index].data();
                            return Column(
                              children: [
                                RunEventContainer(runEvent: event),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            );
                          },
                        ),
                      );
                    }),

                // list run events
                // if (runEvents.isNotEmpty)
                //   Expanded(
                //     child: ListView.builder(
                //       itemCount: runEvents.length,
                //       itemBuilder: (_, index) {
                //         return Column(
                //           children: [
                //             RunEventContainer(runEvent: runEvents[index]),
                //             const SizedBox(
                //               height: 10,
                //             )
                //           ],
                //         );
                //       },
                //     ),
                //   )
                // else
                //   const StyledTitleMedium("No runs yet. Come back later.")
              ],
            )));
  }

  // preserve this page's state
  @override
  bool get wantKeepAlive => true;
}

// REFERENCE: https://dev.to/nicks101/state-persistence-techniques-for-the-flutter-bottom-navigation-bar-3ikc

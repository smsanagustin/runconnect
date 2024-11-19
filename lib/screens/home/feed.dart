import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appUser = ref.watch(profileNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          title: appUser.isNotEmpty
              ? StyledTitleMedium("Hi, ${appUser.first.username}!")
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
                )
              ],
            )));
  }

  // preserve this page's state
  @override
  bool get wantKeepAlive => true;
}

// REFERENCE: https://dev.to/nicks101/state-persistence-techniques-for-the-flutter-bottom-navigation-bar-3ikc

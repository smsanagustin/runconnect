import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/providers/profile_provider.dart';
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
                    StyledText(user!.createdEventIds[index]),
                  ],
                );
              }));
    } else {
      return const StyledText("You haven't hosted any runs yet.");
    }
  }
}

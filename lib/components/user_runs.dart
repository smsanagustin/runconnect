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

    return Column(
      children: [
        if (user != null && user.createdEventIds.isNotEmpty)
          Flexible(
            child: ListView.builder(
              itemCount: user.createdEventIds.length,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    const StyledTitleMedium("Your hosted runs"),
                    StyledText(user!.createdEventIds[index]),
                  ],
                );
              },
            ),
          )
        else
          const StyledText("You haven't hosted any runs yet.")
      ],
    );
  }
}

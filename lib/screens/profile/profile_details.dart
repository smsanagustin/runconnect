import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/shared/styled_text.dart';

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(profileNotifierProvider);
    String _fullName = "";
    String _location = "";

    // get details from appUser
    if (appUser.isNotEmpty) {
      _fullName = appUser.first.fullName;
      _location = appUser.first.location;
    }

    if (appUser.isEmpty) {
      return const CircularProgressIndicator();
    } else {
      return Row(
        children: [
          const Text("pic"),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              StyledTextStrong(_fullName == "" ? "Name not set." : _fullName),
              StyledText(_location == "" ? "Location not set." : _fullName),
            ],
          )
        ],
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/components/user_runs.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/screens/profile/edit_profile.dart';
import 'package:runconnect/screens/profile/profile_details.dart';
import 'package:runconnect/screens/profile/saved_runs.dart';
import 'package:runconnect/services/auth_service.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(profileNotifierProvider); // returns a set

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const StyledTitleMedium("My profile"),
              TextButton(
                  onPressed: () {
                    AuthService.signOut();
                  },
                  child: const StyledText("Log out"))
            ],
          ),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              appUser.isNotEmpty && appUser.first.fullName == ""
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const StyledTitleMedium(
                              "Welcome to RunConnect! Please finish setting up your profile."),
                          const SizedBox(
                            height: 10,
                          ),
                          StyledButton(
                              text: "Edit Profile",
                              color: "blue",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => const EditProfile()));
                              })
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProfileDetails(),
                        const SizedBox(
                          height: 20,
                        ),
                        StyledButton(
                            text: "Edit profile",
                            color: "blue",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => const EditProfile()));
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const StyledTitleMedium("Your runs"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => const SavedRuns()));
                                },
                                child: const StyledUnderlinedText(
                                    "View saved runs")),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        UserRuns(appUser.first),
                      ],
                    )),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/screens/profile/edit_profile.dart';
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
          child: Row(
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
                  : const Column(),
            ],
          ),
        ));
  }
}

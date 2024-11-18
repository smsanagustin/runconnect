import 'package:flutter/material.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/services/auth_service.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/shared/styled_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const StyledText("Profile"),
        ),
        body: Column(
          children: [
            StyledText("Welcome, ${user.email}!"),
            StyledButton(
                text: "Sign out",
                color: "blue",
                onPressed: () {
                  AuthService.signOut();
                })
          ],
        ));
  }
}

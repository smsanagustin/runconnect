import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/services/auth_service.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/shared/styled_text.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appUser = ref.watch(profileNotifierProvider);

    return Scaffold(
        appBar: AppBar(
            title: appUser.isNotEmpty
                ? StyledTitle("Hi, ${appUser.first.username}!")
                : const Text("")),
        body: Column(
          children: [
            StyledButton(
                text: "Log out",
                color: "blue",
                onPressed: () {
                  AuthService.signOut();
                })
          ],
        ));
  }
}

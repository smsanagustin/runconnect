import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/services/auth_service.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/shared/styled_text.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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

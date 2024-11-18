import 'package:flutter/material.dart';
import 'package:runconnect/models/app_user.dart';
import 'package:runconnect/shared/styled_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final AppUser user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("")),
        body: StyledText("Hello, ${widget.user.username}"));
  }
}

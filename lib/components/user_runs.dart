import 'package:flutter/material.dart';
import 'package:runconnect/shared/styled_text.dart';

class UserRuns extends StatefulWidget {
  const UserRuns({super.key});

  @override
  State<UserRuns> createState() => _UserRunsState();
}

class _UserRunsState extends State<UserRuns> {
  @override
  Widget build(BuildContext context) {
    return const StyledText("Runs go here");
  }
}

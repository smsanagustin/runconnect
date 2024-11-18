import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/providers/profile_provider.dart';
import 'package:runconnect/shared/styled_text.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(profileNotifierProvider);
    return Scaffold(
      appBar: AppBar(
          title: appUser.isNotEmpty
              ? StyledTitle("Hi, ${appUser.first.username}!")
              : const Text("")),
    );
  }
}

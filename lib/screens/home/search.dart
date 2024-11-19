import 'package:flutter/material.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const StyledTitleMedium("Search"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                //TODO: should listen to user input and should output results when the user starts typing
                SearchBar(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                  elevation: const WidgetStatePropertyAll(
                      3), // adjusts the shadow of the search bar
                  hintText: "Search a user",
                ),
              ],
            )));
  }
}

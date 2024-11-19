import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = "";

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
                SearchBar(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                  elevation: const WidgetStatePropertyAll(
                      3), // adjusts the shadow of the search bar
                  hintText: "Search a user",
                ),

                // list user results
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('appUsers')
                        .snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState ==
                              ConnectionState.waiting)
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: snapshots.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var data =
                                        snapshots.data!.docs[index].data();
                                    // filter results based on search query
                                    if (searchQuery != "") {
                                      if (data['fullName']
                                          .toString()
                                          .toLowerCase()
                                          .contains(
                                              searchQuery.toLowerCase())) {
                                        return ListTile(
                                            title: Align(
                                                alignment: Alignment.centerLeft,
                                                child: StyledText(
                                                    data['fullName'])),
                                            leading: const Icon(Icons.person));
                                      }
                                      return Container();
                                    }
                                    return Container();
                                  }),
                            );
                    })
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:runconnect/screens/profile/profile_details.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const StyledTitleMedium("Edit profile"),
          backgroundColor: AppColors.primaryColor,
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
          child: Column(
            children: [
              ProfileDetails(),
            ],
          ),
        ));
  }
}

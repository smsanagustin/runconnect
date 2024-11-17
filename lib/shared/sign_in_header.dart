import 'package:flutter/material.dart';
import 'package:runconnect/theme.dart';

class SignInHeader extends StatelessWidget {
  const SignInHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: const EdgeInsets.only(left: 5, top: 60),
      width: double.infinity,
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Align(
            alignment: Alignment.centerLeft,
            child:
                Image.asset("assets/logos/dark_blue_man_logo.png", width: 70)),
        const SizedBox(height: 20),
        Image.asset("assets/logos/dark_blue_banner.png", width: 250),
        const SizedBox(height: 50),
      ]),
    );
  }
}

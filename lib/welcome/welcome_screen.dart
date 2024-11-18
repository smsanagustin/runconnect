import 'package:flutter/material.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/welcome/sign_in.dart';
import 'package:runconnect/welcome/sign_up.dart';

import '../shared/styled_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Column(children: [
          Container(
              margin: const EdgeInsets.only(top: 150),
              child: const StyledTitleLarge("RunConnect")),
          const StyledText("Welcome, runner!"),
          const SizedBox(
            height: 50,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 70),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                      "assets/logos/runconnect_logo_blue_on_blue.png",
                      fit: BoxFit.fill),
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                    width: double.infinity,
                    child: StyledButton(
                      text: "Sign up",
                      color: "blue",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const SignUpForm()));
                      },
                    )),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                    width: double.infinity,
                    child: StyledButton(
                      text: "Sign in",
                      color: "white",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => const SignInForm()));
                      },
                    ))
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}

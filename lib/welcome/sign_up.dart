import 'package:flutter/material.dart';
import 'package:runconnect/shared/sign_in_header.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/theme.dart';
import 'package:runconnect/welcome/sign_in.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SignInHeader(),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: StyledTitle("Sign Up"),
          ),
          Form(
              key: _formGlobalKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: Column(
                  children: [
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          label: const Text("Email address"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColors.textColor, width: 2.0)),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                      label: const Text("Username"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.textColor, width: 2.0)),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          label: const Text("Password"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: AppColors.textColor, width: 2.0)),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    StyledButton(
                      text: "Let's go!",
                      color: "blue",
                      onPressed: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const StyledText("Already have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const SignInForm()));
                          },
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 1)),
                          child: Text("Sign in here",
                              style: TextStyle(
                                  fontFamily: "Cabin",
                                  color: AppColors.textColor,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline)),
                        )
                      ],
                    ),
                    const StyledText("Or sign up with"),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: IconButton(
                          onPressed: () {},
                          icon: Image.asset("assets/logos/google.png",
                              width: 60)),
                    )
                  ],
                ),
              ))
        ],
      ),
    ));
  }
}

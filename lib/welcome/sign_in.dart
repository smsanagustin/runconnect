import 'package:flutter/material.dart';
import 'package:runconnect/shared/sign_in_header.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/theme.dart';
import 'package:runconnect/welcome/sign_up.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
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
            child: StyledTitle("Sign In"),
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
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return "You must input your email to log in.";
                        }
                        return null;
                      },
                    ),
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
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return "You must input a password.";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StyledButton(
                      text: "Let's go!",
                      color: "blue",
                      onPressed: () {
                        _formGlobalKey.currentState!.validate();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const StyledText("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => const SignUpForm()));
                          },
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 1)),
                          child: Text("Sign up here",
                              style: TextStyle(
                                  fontFamily: "Cabin",
                                  color: AppColors.textColor,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline)),
                        )
                      ],
                    ),
                    const StyledText("Or sign in with"),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runconnect/services/auth_service.dart';
import 'package:runconnect/shared/sign_in_header.dart';
import 'package:runconnect/shared/styled_text.dart';
import 'package:runconnect/shared/styled_button.dart';
import 'package:runconnect/theme.dart';
import 'package:runconnect/welcome/sign_in.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formGlobalKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // stores form field values
  String _errorMessage = "";
  String _emailAddress = "";
  String _username = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SignInHeader(),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: StyledTitleLarge("Sign Up"),
          ),
          Form(
              key: _formGlobalKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        label: const Text("Email address"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.textColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppColors.textColor, width: 2.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "You must input an email address.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _emailAddress = value!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
                      decoration: InputDecoration(
                        label: const Text("Username"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.textColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppColors.textColor, width: 2.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "You must input a username.";
                        }
                        if (value.trim().contains(' ')) {
                          return "Username cannot contain spaces.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!.trim();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Cabin", color: AppColors.textColor),
                      obscureText: true,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.textColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: AppColors.textColor, width: 2.0)),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return "Invalid password.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_errorMessage.isNotEmpty)
                      Column(
                        children: [
                          StyledErrorText(_errorMessage),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    if (!_isLoading)
                      StyledButton(
                        text: "Let's go!",
                        color: "blue",
                        onPressed: () async {
                          if (_formGlobalKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = "";
                            });

                            _formGlobalKey.currentState!.save();

                            final result = await AuthService.signUpUser(
                                _emailAddress, _password, _username);

                            // handle return values depending on whether it returned AppUser (user) or a String (error)
                            result.fold((user) {
                              if (user == null) {
                                setState(() {
                                  _errorMessage =
                                      "Invalid sign up details. Please check your email and password then try again.";
                                });
                              } else {
                                // user successfully signed up
                                _formGlobalKey.currentState!.reset();

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            }, (error) {
                              setState(() {
                                _errorMessage = error;
                              });
                            });

                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      ),
                    if (_isLoading)
                      StyledButton(
                        text: "Loading...",
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

import 'package:flutter/material.dart';
import 'package:runconnect/theme.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Cabin", color: AppColors.textColor, fontSize: 15),
      textAlign: TextAlign.center,
    );
  }
}

class StyledErrorText extends StatelessWidget {
  const StyledErrorText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Cabin", color: AppColors.errorColor, fontSize: 15),
      textAlign: TextAlign.center,
    );
  }
}

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontFamily: "Cabin",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor));
  }
}

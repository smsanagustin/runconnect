import 'package:flutter/material.dart';
import 'package:runconnect/theme.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: "Cabin", color: AppColors.textColor, fontSize: 15),
      textAlign: TextAlign.center,
    );
  }
}

class StyledTextSmall extends StatelessWidget {
  const StyledTextSmall(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontFamily: "Cabin", color: Colors.white, fontSize: 10),
      textAlign: TextAlign.center,
    );
  }
}

class StyledTextStrong extends StatelessWidget {
  const StyledTextStrong(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Cabin",
          color: AppColors.textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold),
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

class StyledTitleLarge extends StatelessWidget {
  const StyledTitleLarge(this.text, {super.key});
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

class StyledTitleMedium extends StatelessWidget {
  const StyledTitleMedium(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontFamily: "Cabin",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor));
  }
}

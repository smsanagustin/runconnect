import 'package:flutter/material.dart';
import 'package:runconnect/theme.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(
      {required this.text,
      required this.color,
      required this.onPressed,
      super.key});
  final String text;
  final String color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: color == "blue" ? AppColors.textColor : Colors.white,
        side: BorderSide(color: AppColors.textColor, width: 1),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text,
            style: TextStyle(
                fontFamily: "Cabin",
                color: color == "blue"
                    ? AppColors.primaryColor
                    : AppColors.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
    );
  }
}

class StyledButtonSmall extends StatelessWidget {
  const StyledButtonSmall(
      {required this.text,
      required this.color,
      required this.onPressed,
      super.key});
  final String text;
  final String color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor:
            color == "lightBlue" ? AppColors.primaryColor : Colors.white,
        side: BorderSide(color: AppColors.primaryColor, width: 1),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text,
            style: TextStyle(
                fontFamily: "Cabin",
                color: color == "blue"
                    ? AppColors.primaryColor
                    : AppColors.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ),
    );
  }
}

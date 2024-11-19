// border
import 'package:flutter/material.dart';
import 'package:runconnect/theme.dart';

// border of text fields
OutlineInputBorder textFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColors.textColor));

// border of text fields when focused
InputBorder textFieldFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: AppColors.textColor, width: 2.0));

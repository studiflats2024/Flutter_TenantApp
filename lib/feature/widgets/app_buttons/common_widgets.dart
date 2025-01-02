import 'package:flutter/material.dart';

Widget labelTextWidget(String title, Color? textColor) {
  return Text(
    title,
    style: TextStyle(
      color: textColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
}

import 'package:flutter/material.dart';

sealed class AppTextStyles {
  static const button = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Roboto',
  );

  static const labelMedium = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );
}

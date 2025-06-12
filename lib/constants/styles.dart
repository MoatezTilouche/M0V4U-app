// lib/styles.dart

import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color(0xFFf8f9fb);
  static const Color secondaryColor = Color(0xFF112155);
  static const Color textColor = Color(0xFF000000);

  static const TextStyle headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: textColor,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const String fontFamily = 'Roboto';
}

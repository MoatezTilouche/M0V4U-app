// lib/styles.dart

import 'package:flutter/material.dart';

class AppStyles {
  static const Color primaryColor = Color(0xFFf8f9fb);
  static const Color secondaryColor = Color(0xFF112155);
  static const Color darkColor = Color(0xFF09122C);
  static const Color textColor = Color(0xFF000000);
    static const Color whiteBlue =  Color(0xFFc1f7ff);
    static const Color cardColor=Color(0xFFF8f9fb);

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

  static const Color userBubbleColor = Color(0xFF1E88E5); // Blue for user messages
  static const Color botBubbleColor = Color(0xFFE0E0E0); // Light grey for bot messages
  static const Color userTextColor = Colors.white;
  static const Color botTextColor = Colors.black87;
  static const Color sendButtonColor = Color(0xFF1E88E5);
}

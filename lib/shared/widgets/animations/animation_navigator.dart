import 'package:flutter/material.dart';

class AnimatedNavigator {
  /// Zoom-In animated push transition
  static void pushZoomIn(BuildContext context, Widget destination) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 850),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutExpo,
            reverseCurve: Curves.easeInExpo,
          );
          return ScaleTransition(
            scale: curved,
            alignment: Alignment.center,
            child: child,
          );
        },
      ),
    );
  }
}

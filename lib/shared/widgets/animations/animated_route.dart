import 'package:flutter/material.dart';

class AnimatedRoute {
  static PageRouteBuilder fade(Widget page, {String? routeName}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),

      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder slideFromBottom(Widget page, {String? routeName}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeName),

      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final offsetAnimation =
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

import 'package:app_m0v4u/constants/assets.dart';
import 'package:flutter/material.dart';

class PaginationButtonWidget extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const PaginationButtonWidget(
      {super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.black, // Add splash color for visual feedback
        highlightColor: Colors.black, // Add highlight color
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2), // Shadow color
                offset: Offset(0, 4), // Shadow position
                blurRadius: 6, // Shadow blur radius
              ),
            ],
          ),
          child: Image.asset(
            icon,
            fit: BoxFit
                .contain, // Ensure the image is contained within the container
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../constants/styles.dart';

class CustomDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26C6DA), Color(0xFF00C853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white54, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: AppStyles.darkColor),
        dropdownColor: AppStyles.primaryColor, // menu background color
        borderRadius: BorderRadius.circular(12),
        items: ['Movies', 'TV Shows'].map((String type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),

              ),
              child: Text(
                type,
                style: TextStyle(
                  color: AppStyles.darkColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

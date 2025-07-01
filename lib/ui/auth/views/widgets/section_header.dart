import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/custom_dropbutton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String value;
  final ValueChanged<String?> onChanged;

  const SectionHeader({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AutoSizeText(
          title,
          maxLines: 2,
          style: TextStyle(
            color: AppStyles.darkColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 15,
        ),
        CustomDropdown(value: value, onChanged: onChanged),
      ],
    );
  }
}

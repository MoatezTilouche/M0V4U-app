import 'package:app_m0v4u/constants/styles.dart';
import 'package:flutter/material.dart';

class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppStyles.primaryColor,
              Color(0xfff6f6f6)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 75,
              color: Colors.grey[300],
            ),
          ),
          title: Container(
            height: 16,
            width: 100,
            color: Colors.grey[300],
          ),
          subtitle: Container(
            height: 12,
            width: 40,
            color: Colors.grey[300],
          ),
          trailing: Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

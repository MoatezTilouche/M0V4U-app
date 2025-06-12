import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String textButton;
  const ButtonWidget({super.key, this.onPressed, required this.textButton});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        height: 50,
        width: 200,
        child: Text(textButton),
      ),
    );
  }
}

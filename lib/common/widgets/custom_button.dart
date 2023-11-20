import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const CustomButton(
      {Key? key, required this.text, required this.onTap, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(color: color == null ? Colors.white : Colors.black),
        ));
  }
}

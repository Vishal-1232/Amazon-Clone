import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const CustomButton(
      {Key? key, required this.text, required this.onTap, this.color})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isEnabled = true;

  void _handleTap() async {
    if (_isEnabled) {
      setState(() {
        _isEnabled = false; // Disable the button
      });

      widget.onTap(); // Execute the original onTap action

      // Delay for 500ms
      await Future.delayed(const Duration(milliseconds: 1000));

      setState(() {
        _isEnabled = true; // Re-enable the button
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: _isEnabled ? _handleTap : null,
        child: Text(
          widget.text,
          style: TextStyle(color: widget.color == null ? Colors.white : Colors.black),
        ));
  }
}

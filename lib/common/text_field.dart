import 'package:flutter/material.dart';

class PentoTextField extends StatelessWidget {
  const PentoTextField(
      {super.key,
      required this.controller,
      required this.label,
      this.obscureText = false,
      this.keyboardType = TextInputType.text});

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
        focusColor: Colors.white,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}

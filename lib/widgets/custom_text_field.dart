import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.symmetric(vertical: 8.0),
      height: 45,
      //alignment: Alignment(1, 1),
      child: TextField(
        textAlign: TextAlign.start,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
           // borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
           // borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
          //labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}

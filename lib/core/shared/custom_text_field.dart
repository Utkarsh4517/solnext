import 'package:flutter/material.dart';
import 'package:solnext/core/constants/dimensions.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  const CustomTextField({
    this.obscure = false,
    required this.controller,
    required this.label,
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.05,
        vertical: getScreenWidth(context) * 0.04,
      ),
      child: SizedBox(
        child: TextField(
          obscureText: widget.obscure,
          controller: widget.controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              filled: true,
              labelText: widget.label,
              fillColor: const Color.fromARGB(255, 247, 247, 247),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.white))),
        ),
      ),
    );
  }
}



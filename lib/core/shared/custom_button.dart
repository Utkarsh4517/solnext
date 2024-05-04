
import 'package:flutter/material.dart';
import 'package:solnext/core/constants/dimensions.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback function;
  final bool isAsync;
  const CustomButton({
    this.isAsync = false,
    required this.text,
    required this.function,
    super.key,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
        widget.function();
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      child: AnimatedContainer(
        width: getScreenWidth(context),
        margin: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * (isTapped ? 0.1 : 0.05),
          vertical: getScreenWidth(context) * 0.02,
        ),
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.symmetric(
          vertical: getScreenWidth(context) * 0.035,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}



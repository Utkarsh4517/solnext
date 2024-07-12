import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/dimensions.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color =  const Color(0xff715AFF),
  });
  final Function onPressed;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: getScreenWidth(context) * 0.04,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

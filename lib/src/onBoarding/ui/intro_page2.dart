import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            left: getScreenWidth(context) * 0.085,
            top: getScreenheight(context) * 0.25,
            child: SizedBox(
              width: getScreenWidth(context) * 0.3,
              child: Text(
                'Fast. Safe.',
                style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.1, height: 1),
              ),
            )),
        Positioned(
            left: getScreenWidth(context) * 0.085,
            top: getScreenheight(context) * 0.35,
            child: SizedBox(
              width: getScreenWidth(context) * 0.6,
              child: Text(
                'Solana.',
                style: GoogleFonts.poppins(color: purple, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.12, height: 1),
              ),
            )),
      ],
    ));
  }
}

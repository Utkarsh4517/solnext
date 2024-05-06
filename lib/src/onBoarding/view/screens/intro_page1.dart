import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          left: getScreenWidth(context) * 0.18,
          top: getScreenheight(context) * 0.79,
          child: Image.asset('assets/img/stroke.png', scale: 1.2),
        ),
        Positioned(
          right: 0,
          child: SvgPicture.asset('assets/svgs/page1_vector.svg'),
        ),
        Positioned(
          left: getScreenWidth(context) * 0.05,
          top: getScreenheight(context) * 0.24,
          child: SvgPicture.asset('assets/svgs/wallet.svg'),
        ),
        Positioned(
          left: getScreenWidth(context) * 0.05,
          top: getScreenheight(context) * 0.74,
          child: SvgPicture.asset('assets/svgs/stroke.svg'),
        ),
        Positioned(
            left: getScreenWidth(context) * 0.06,
            top: getScreenheight(context) * 0.45,
            child: SizedBox(
              width: getScreenWidth(context) * 0.6,
              child: Text(
                'Securely Power your Solana Experience with',
                style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.1, height: 1),
              ),
            )),
        Positioned(
            left: getScreenWidth(context) * 0.06,
            top: getScreenheight(context) * 0.75,
            child: SizedBox(
              width: getScreenWidth(context) * 0.6,
              child: Text(
                'Solnext',
                style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.12, height: 1),
              ),
            )),

      ],
    ));
  }
}

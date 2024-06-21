import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/constants/shadows.dart';


class SwapButton extends StatelessWidget {
  const SwapButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: getScreenWidth(context) * 0.325),
      padding: EdgeInsets.symmetric(horizontal:  getScreenWidth(context) * 0.035, vertical: getScreenWidth(context) * 0.015),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: boxShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Swap ',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: getScreenWidth(context) * 0.028),
          ),
          SvgPicture.asset('assets/svgs/swap.svg', width: 15, height: 15)
        ],
      ),
    );
  }
}

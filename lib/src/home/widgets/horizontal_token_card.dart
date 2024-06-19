import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/constants/shadows.dart';


class HorizontalTokenCard extends StatelessWidget {
  const HorizontalTokenCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getScreenWidth(context) * 0.03),
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.03,
        vertical: getScreenWidth(context) * 0.03,
      ),
      width: getScreenWidth(context)  * 0.94,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/solana.svg'),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Solana', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: black2)),
                      Text('0 SOL', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: black2))
                    ],
                  )
                ],
              )
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$137.22', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: black2)),
              Text('\$4.44', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: green))
            ],
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/constants/shadows.dart';


class ScanAQrButton extends StatelessWidget {
  const ScanAQrButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: getScreenWidth(context) * 0.325),
      padding: EdgeInsets.all(getScreenWidth(context) * 0.025),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: boxShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Scan a  ',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
          SvgPicture.asset('assets/svgs/qr.svg', width: 20, height: 20)
        ],
      ),
    );
  }
}

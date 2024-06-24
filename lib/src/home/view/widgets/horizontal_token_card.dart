import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/constants/shadows.dart';

class HorizontalTokenCard extends StatelessWidget {
  final String price;
  final String priceInUsd;
  final String changeInPriceInUsd;
  final String tokenName;
  final String tokenCurrencyName;
  final String imgPath;
  const HorizontalTokenCard({
    super.key,
    required this.price,
    required this.priceInUsd,
    required this.changeInPriceInUsd,
    required this.tokenName,
    required this.tokenCurrencyName,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(getScreenWidth(context) * 0.03),
      margin: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.04,
        vertical: getScreenWidth(context) * 0.03,
      ),
      width: getScreenWidth(context) * 0.92,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svgs/$imgPath.svg'),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$tokenCurrencyName', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: black2)),
                      Text('$price $tokenName', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: black2))
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
              Text('\$$priceInUsd', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: black2)),
              Text(
                '${double.parse(changeInPriceInUsd) < 0 ? "-\$${(double.parse(changeInPriceInUsd) * -1)}" : "+\$${changeInPriceInUsd}"}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: double.parse(changeInPriceInUsd) > 0 ? green : red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

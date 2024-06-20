import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';


class AnimatedPriceTextWidget extends StatelessWidget {
  const AnimatedPriceTextWidget({
    super.key,
    required this.balanceInUsd,
  });

  final String balanceInUsd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getScreenWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              "\$$balanceInUsd",
              key: ValueKey<String>(balanceInUsd),
              style: GoogleFonts.poppins(
                fontSize: getScreenWidth(context) * 0.15,
                fontWeight: FontWeight.bold,
                color: black2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

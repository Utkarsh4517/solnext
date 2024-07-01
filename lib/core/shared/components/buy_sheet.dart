import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/constants/shadows.dart';
import 'package:url_launcher/url_launcher.dart';

class BuySheet extends StatefulWidget {
  const BuySheet({super.key});

  @override
  State<BuySheet> createState() => _BuySheetState();
}

class _BuySheetState extends State<BuySheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: getScreenheight(context) * 0.05),
          GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse('https://www.moonpay.com/buy'));
            },
            child: Container(
              padding: EdgeInsets.all(getScreenWidth(context) * 0.03),
              margin: EdgeInsets.symmetric(
                horizontal: getScreenWidth(context) * 0.04,
                vertical: getScreenWidth(context) * 0.03,
              ),
              width: getScreenWidth(context) * 0.92,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: boxShadow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/img/Moonpay.png', scale: 2.5),
                  Text(
                    'Buy With MoonPay',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: getScreenWidth(context) * 0.045,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: getScreenheight(context) * 0.02),
          SizedBox(
            width: getScreenWidth(context) * 0.8,
            child: Text(
              'Once the transaction is completed on MoonPay, transfer the purchased crypto to your SolNext wallet address.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.035, color: black2),
            ),
          ),
        ],
      ),
    );
  }
}

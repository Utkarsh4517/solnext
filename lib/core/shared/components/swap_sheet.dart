import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';

class SwapSheet extends StatefulWidget {
  const SwapSheet({super.key});

  @override
  State<SwapSheet> createState() => _SwapSheetState();
}

class _SwapSheetState extends State<SwapSheet> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context),
      height: getScreenheight(context) * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          gradient: LinearGradient(
            colors: [Color(0xff191628), Color(0xff715aff)],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(
        children: [
          Container(
            width: getScreenWidth(context),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(getScreenWidth(context) * 0.04),
            margin: EdgeInsets.all(getScreenWidth(context) * 0.04),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svgs/solana.svg'),
                    SizedBox(width: getScreenWidth(context) * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Solana',
                          style: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Balance: 10 SOL',
                          style: GoogleFonts.poppins(
                            color: Color(0xffB6B6B6),
                            fontWeight: FontWeight.w500,
                            fontSize: getScreenWidth(context) * 0.03,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: getScreenheight(context) * 0.025),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(top: 10, right: 10),
                      child: Text(
                        'MAX',
                        style: GoogleFonts.poppins(color: purple, fontWeight: FontWeight.w600, fontSize: getScreenWidth(context) * 0.05),
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: '0 SOL',
                    hintStyle: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.05),
                    fillColor: Color(0xff161616),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: Color(0xffB6B6B6),
                    fontWeight: FontWeight.w700,
                    fontSize: getScreenWidth(context) * 0.05,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset('assets/svgs/swap.svg'),
          Container(
            width: getScreenWidth(context),
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
            padding: EdgeInsets.all(getScreenWidth(context) * 0.04),
            margin: EdgeInsets.all(getScreenWidth(context) * 0.04),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svgs/usdCoin.svg'),
                    SizedBox(width: getScreenWidth(context) * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'USD Coin',
                          style: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'USDC',
                          style: GoogleFonts.poppins(
                            color: Color(0xffB6B6B6),
                            fontWeight: FontWeight.w500,
                            fontSize: getScreenWidth(context) * 0.03,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: getScreenheight(context) * 0.025),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    border: InputBorder.none,
                    hintText: '1287.60777',
                    hintStyle: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.05),
                    fillColor: Color(0xff161616),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    color: Color(0xffB6B6B6),
                    fontWeight: FontWeight.w700,
                    fontSize: getScreenWidth(context) * 0.05,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: getScreenheight(context) * 0.34,
          ),
          SizedBox(
            width: getScreenWidth(context) * 0.9,
            height: getScreenWidth(context) * 0.125,
            child: PrimaryButton(
              onPressed: () {},
              text: 'Confirm Swap',
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/swap_transaction_loading_sheet.dart';
import 'package:solnext/core/utils/jupiter.dart';
import 'package:solnext/core/utils/print_log.dart';
import 'package:solnext/core/utils/tracker.dart';

class SwapSheet extends StatefulWidget {
  const SwapSheet({super.key});

  @override
  State<SwapSheet> createState() => _SwapSheetState();
}

class _SwapSheetState extends State<SwapSheet> {
  Timer? _timer;
  String _priceInSol = '';
  String _priceOfSolInUsd = '';
  String _priceInUsdc = '';
  String _priceOfUsdcInUsd = '';
  String _publicAddress = '';
  final solController = TextEditingController();
  final usdcController = TextEditingController();
  Color textColor = Color(0xffB6B6B6);
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    fetch();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      fetch();
    });
  }

  fetch() async {
    final balance = await Tracker.fetchBalance();
    setState(() {
      _priceInSol = balance.priceInSol;
      _priceOfSolInUsd = balance.priceOfSolInUsd;
      _priceInUsdc = balance.priceInUsdc;
      _priceOfUsdcInUsd = balance.priceOfUsdcInUsd;
      _publicAddress = balance.publicAddress;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          gradient: LinearGradient(
            colors: [Color(0xff191628), Color(0xff715aff)],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                          'Balance: $_priceInSol SOL',
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
                  onChanged: (value) async {
                    if (double.parse(solController.text) == 0.0 || solController.text.isEmpty) {
                      setState(() {
                        textColor = Color(0xffB6B6B6);
                        isButtonEnabled = false;
                        usdcController.text = '';
                      });
                    }
                    if (double.parse(solController.text) > double.parse(_priceInSol)) {
                      setState(() {
                        textColor = Colors.red;
                        isButtonEnabled = false;
                        PrintLog.printLog(Jupiter.quoteResponse);
                      });
                    } else {
                      setState(() {
                        textColor = Color(0xffB6B6B6);
                        isButtonEnabled = true;
                      });
                      final res = await Jupiter.getSolToUsdcQuote(amount: solController.text, slippage: '50');
                      usdcController.text = res.toString();
                    }
                  },
                  controller: solController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        solController.text = _priceInSol;
                        final res = await Jupiter.getSolToUsdcQuote(amount: solController.text, slippage: '50');
                        setState(() {
                          usdcController.text = res.toString();
                          isButtonEnabled = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                          'MAX',
                          style: GoogleFonts.poppins(color: purple, fontWeight: FontWeight.w600, fontSize: getScreenWidth(context) * 0.05),
                        ),
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
                    color: textColor,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'USD Coin',
                              style: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: getScreenWidth(context) * 0.25),
                            Text(
                              'USD Coin',
                              style: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.bold),
                            ),
                          ],
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
                  controller: usdcController,
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.05),
                    fillColor: Color(0xff161616),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    disabledBorder: OutlineInputBorder(
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
            width: getScreenWidth(context) * 0.85,
            height: getScreenWidth(context) * 0.125,
            child: PrimaryButton(
              onPressed: () async {
                Navigator.pop(context);
                return showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25.0),
                          bottom: Radius.circular(25.0),
                        ),
                        child: SwapTransactionLoadingSheet(userPublicKey: _publicAddress),
                      ),
                    );
                  },
                );
              },
              text: 'Confirm Swap',
              color: isButtonEnabled ? Colors.black : Colors.grey.shade500,
            ),
          ),
          SizedBox(height: getScreenheight(context) * 0.02),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/send_sol_loading_sheet.dart';
import 'package:solnext/core/shared/components/send_usdc_loading_sheet.dart';
import 'package:solnext/core/utils/print_log.dart';
import 'package:solnext/core/utils/transaction_manager.dart';

class SendMoneySheet extends StatefulWidget {
  final String? toAddress;
  final Token tokenType;

  const SendMoneySheet({super.key, this.toAddress, required this.tokenType});

  @override
  State<SendMoneySheet> createState() => _SendMoneySheetState();
}

enum Token { SOL, USDC }

class _SendMoneySheetState extends State<SendMoneySheet> with SingleTickerProviderStateMixin {
  final _tokenAmountController = TextEditingController();
  final _receiverAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.toAddress != null) {
      _receiverAddressController.text = widget.toAddress!;
    }
    if (widget.tokenType == Token.SOL) {
      tokenType = 'SOL';
    } else {
      tokenType = 'USDC';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  String currentState = '';
  String tokenType = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: getScreenWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: gradient,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: getScreenheight(context) * 0.02),
            if (currentState == '') _buildSendTab(tokenType),
          ],
        ),
      ),
    );
  }

  Widget _buildSendTab(String tokenType) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: getScreenheight(context) * 0.015),
          if (currentState == '')
            SizedBox(
              width: getScreenWidth(context) * 0.6,
              child: Text(
                'Send $tokenType to a different wallet seamlessly using solnext.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.03, color: Colors.white),
              ),
            ),
          SizedBox(height: getScreenheight(context) * 0.015),
          if (currentState == '')
            TextField(
              controller: _receiverAddressController,
              enabled: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                border: InputBorder.none,
                hintText: 'Receiver\'s address',
                hintStyle: GoogleFonts.poppins(color: Color(0xffB6B6B6), fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.04),
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
                fontSize: getScreenWidth(context) * 0.04,
              ),
            ),
          if (currentState == '') SizedBox(height: getScreenheight(context) * 0.02),
          if (currentState == '')
            TextField(
              keyboardType: TextInputType.number,
              controller: _tokenAmountController,
              enabled: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: InputBorder.none,
                hintText: '$tokenType amount to transfer',
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
          if (currentState == '') SizedBox(height: getScreenheight(context) * 0.02),
          if (currentState == '')
            PrimaryButton(
                color: Color(0xff161616),
                onPressed: () async {
                  if (tokenType == 'SOL') {
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
                            child: SendSolLoadingSheet(amountInSol: double.parse(_tokenAmountController.text), receiverAddress: _receiverAddressController.text),
                          ),
                        );
                      },
                    );
                  } else if (tokenType == 'USDC') {
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
                            child: SendUsdcLoadingSheet(amountInUsdc: double.parse(_tokenAmountController.text), receiverAddress: _receiverAddressController.text),
                          ),
                        );
                      },
                    );
                  }
                  PrintLog.printLog(currentState);
                },
                text: 'Send $tokenType'),
        ],
      ),
    );
  }
}

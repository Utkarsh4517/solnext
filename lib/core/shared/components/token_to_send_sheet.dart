import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/send_money.dart';
import 'package:solnext/src/home/view/widgets/horizontal_token_card.dart';

class TokenToSendSheet extends StatefulWidget {
  final HorizontalTokenCard solana;
  final HorizontalTokenCard usdc;
  const TokenToSendSheet({
    super.key,
    required this.solana,
    required this.usdc,
  });

  @override
  State<TokenToSendSheet> createState() => _TokenToSendSheetState();
}

class _TokenToSendSheetState extends State<TokenToSendSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
      width: getScreenWidth(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: getScreenheight(context) * 0.02),
          SizedBox(
            width: getScreenWidth(context) * 0.6,
            child: Text(
              'Select a token to send',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.03, color: Colors.white),
            ),
          ),
          SizedBox(height: getScreenheight(context) * 0.01),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(25.0),
                        bottom: Radius.circular(10.0),
                      ),
                      child: SendMoneySheet(tokenType: Token.SOL),
                    ),
                  );
                },
              );
            },
            child: widget.solana,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(25.0),
                        bottom: Radius.circular(10.0),
                      ),
                      child: SendMoneySheet(tokenType: Token.USDC),
                    ),
                  );
                },
              );
            },
            child: widget.usdc,
          ),
        ],
      ),
    );
  }
}

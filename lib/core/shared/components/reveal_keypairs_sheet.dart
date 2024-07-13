import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';
import 'package:solnext/core/utils/wallet_service.dart';

class RevealKeypairsSheet extends StatefulWidget {
  const RevealKeypairsSheet({
    super.key,
  });

  @override
  State<RevealKeypairsSheet> createState() => _RevealKeypairsSheetState();
}

class _RevealKeypairsSheetState extends State<RevealKeypairsSheet> {
  @override
  void initState() {
    super.initState();
    fetchMnemonic();
  }

  String mnemonics = '';
  bool isRevealed = false;

  fetchMnemonic() async {
    final res = await WalletService.getMnemonics();
    setState(() {
      mnemonics = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      width: getScreenWidth(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: getScreenheight(context) * 0.02),
          SizedBox(
            width: getScreenWidth(context) * 0.75,
            child: Text(
              'These 12 words mnemonics are the key to your wallet. Keep them safe and secure. Do not share them with anyone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: getScreenWidth(context) * 0.03,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: getScreenheight(context) * 0.02),
          Container(
            width: getScreenWidth(context) * 0.85,
            height: getScreenheight(context) * 0.11,
            decoration: BoxDecoration(
              color: Color(0xff161616),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(getScreenWidth(context) * 0.02),
            margin: EdgeInsets.symmetric(
              horizontal: getScreenWidth(context) * 0.05,
              vertical: getScreenheight(context) * 0.02,
            ),
            child: isRevealed
                ? Text(
                    mnemonics,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: getScreenWidth(context) * 0.04,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : SecondaryButton(
                    onPressed: () {
                      setState(() {
                        isRevealed = true;
                      });
                    },
                    text: 'Reveal Mnemonics',
                    color: Colors.white,
                  ),
          ),
          if (isRevealed)
            SecondaryButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: mnemonics));
              },
              text: 'Copy Mnemonics',
              color: Colors.white,
            )
        ],
      ),
    );
  }
}

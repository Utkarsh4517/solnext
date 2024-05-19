import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solana/solana.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';
import 'package:solnext/src/onBoarding/view/screens/all_done_scree.dart';

class WalletCreatedScreen extends StatefulWidget {
  final Ed25519HDKeyPair keyPair;
  final String mnemonic;
  const WalletCreatedScreen({
    super.key,
    required this.keyPair,
    required this.mnemonic,
  });

  @override
  State<WalletCreatedScreen> createState() => _WalletCreatedScreenState();
}

class _WalletCreatedScreenState extends State<WalletCreatedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: getScreenheight(context) * 0.13),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Secret Recovery',
            style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.09, height: 1),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Phrase',
            style: GoogleFonts.poppins(color: purple, fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.09, height: 1),
          ),
        ),
        SizedBox(height: getScreenheight(context) * 0.13),
        Container(
          decoration: BoxDecoration(color: const Color(0xffEBEBEB), borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.03, vertical: getScreenWidth(context) * 0.06),
          margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.08),
          alignment: Alignment.center,
          child: Text(
            widget.mnemonic,
            style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.w700, fontSize: getScreenWidth(context) * 0.065, height: 1),
          ),
        ),
        SecondaryButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.mnemonic));
            },
            text: 'Copy to clipboard'),
        SizedBox(height: getScreenheight(context) * 0.13),
        SizedBox(
          width: getScreenWidth(context) * 0.6,
          child: Text(
            'This is the only way you will be able to recover your account. Please store it somewhere else safely.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.03, color: black2),
          ),
        ),
        SizedBox(height: getScreenheight(context) * 0.08),
        SizedBox(
          width: getScreenWidth(context) * 0.9,
          height: getScreenheight(context) * 0.055,
          child: PrimaryButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllDoneScreen()));
              },
              text: 'I Saved it somewhere'),
        ),
      ],
    ));
  }
}

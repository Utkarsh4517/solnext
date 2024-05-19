import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solana/solana.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';
import 'package:solnext/core/utils/wallet.dart';
import 'package:solnext/src/onBoarding/data/services/create_wallet.dart';
import 'package:solnext/src/onBoarding/view/screens/wallet_created_screen.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  State<IntroPage3> createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  @override
  void initState() {
    createWallet();
    super.initState();
  }

  Ed25519HDKeyPair? keyPairGenerated;
  String? mnemonicGenerated;

  createWallet() async {
    final (keypair, mnemonic) = await CreateWallet.createNewWallet();
    setState(() {
      keyPairGenerated = keypair;
      mnemonicGenerated = mnemonic;
    });
    WalletService.savePublicKey(publicKey: keypair.publicKey.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            left: getScreenWidth(context) * 0.055,
            top: getScreenheight(context) * 0.08,
            child: SizedBox(
              width: getScreenWidth(context) * 0.6,
              child: Text(
                'While we are Connecting you to the Solana Ecosystem...',
                style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.065, height: 1),
              ),
            )),
        Positioned(
          left: getScreenWidth(context) * 0.3,
          top: getScreenheight(context) * 0.35,
          child: SvgPicture.asset('assets/svgs/lock.svg'),
        ),
        Positioned(
            left: getScreenWidth(context) * 0.11,
            top: getScreenheight(context) * 0.575,
            child: SizedBox(
              child: Text(
                'Protect your wallet',
                style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.08, height: 1),
              ),
            )),
        Positioned(
          bottom: getScreenheight(context) * 0.05,
          left: getScreenWidth(context) * 0.05,
          child: SizedBox(
            width: getScreenWidth(context) * 0.9,
            height: getScreenheight(context) * 0.055,
            child: PrimaryButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalletCreatedScreen(keyPair: keyPairGenerated!, mnemonic: mnemonicGenerated!),
                    ),
                  );
                },
                text: 'Next'),
          ),
        ),
      ],
    ));
  }
}

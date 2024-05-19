import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/src/onBoarding/view/screens/wallet_created_screen.dart';

class AllDoneScreen extends StatefulWidget {
  const AllDoneScreen({super.key});

  @override
  State<AllDoneScreen> createState() => _AllDoneScreenState();
}

class _AllDoneScreenState extends State<AllDoneScreen> {
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
        SizedBox(height: getScreenheight(context) * 0.39),
        Container(
          alignment: Alignment.center,
          child: Text(
            "You're all done!",
            style: GoogleFonts.poppins(color: black2, fontWeight: FontWeight.bold, fontSize: getScreenWidth(context) * 0.09, height: 1),
          ),
        ),
         Container(
          margin: const EdgeInsets.only(top: 20),
          width: getScreenWidth(context) * 0.65,
          alignment: Alignment.center,
          child: Text(
            "Your wallet is ready to use",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: purple, fontWeight: FontWeight.w400, fontSize: getScreenWidth(context) * 0.065, height: 1.3),
          ),
        ),
        SizedBox(height: getScreenheight(context) * 0.37),
        SizedBox(
          width: getScreenWidth(context) * 0.9,
          height: getScreenheight(context) * 0.055,
          child: PrimaryButton(
              onPressed: () {
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => WalletCreatedScreen(keyPair: keyPairGenerated!, mnemonic: mnemonicGenerated!),
                //   ),
                // );
              },
              text: 'Continue'),
        ),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';
import 'package:solnext/core/utils/wallet_service.dart';
import 'package:solnext/src/onBoarding/data/services/create_wallet.dart';
import 'package:solnext/src/onBoarding/view/screens/all_done_scree.dart';

class ImportWalletSheet extends StatefulWidget {
  const ImportWalletSheet({
    super.key,
  });

  @override
  State<ImportWalletSheet> createState() => _ImportWalletSheetState();
}

class _ImportWalletSheetState extends State<ImportWalletSheet> {
  final privateKeyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(14))),
      width: getScreenWidth(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: getScreenheight(context) * 0.02),
          SizedBox(
            width: getScreenWidth(context) * 0.6,
            child: Text(
              'Enter your PRIVATE key to import your wallet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.03, color: Colors.black),
            ),
          ),
          SizedBox(height: getScreenheight(context) * 0.06),
          Container(
  margin: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05),
  height: getScreenheight(context) * 0.2,
  child: TextField(
    controller: privateKeyController,
    maxLines: null,
    expands: true,
    textAlignVertical: TextAlignVertical.top,
    decoration: InputDecoration(
      hintText: 'Enter your private key',
      hintStyle: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.05, color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
  ),
),

          SecondaryButton(
              onPressed: () async {
                final res = await CreateWallet.generateWalletFromPrivateKey(privateKeyController.text);
                await WalletService.savePublicKey(publicKey: res.publicKey.toString());
                final privateKey = await CreateWallet.getPrivateKey(res);
                await WalletService.savePrivateKey(privateKey: privateKey);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllDoneScreen()));
              },
              text: 'Import Wallet'),
          SizedBox(height: getScreenheight(context) * 0.02),
        ],
      ),
    );
  }
}

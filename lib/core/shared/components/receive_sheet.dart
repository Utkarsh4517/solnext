import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';

class ReceiveSheet extends StatefulWidget {
  final String address;
  const ReceiveSheet({
    super.key,
    required this.address,
  });

  @override
  State<ReceiveSheet> createState() => _ReceiveSheetState();
}

class _ReceiveSheetState extends State<ReceiveSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(14))
      ),
      width: getScreenWidth(context),
      child: Column(
        children: [
          SizedBox(height: getScreenheight(context) * 0.02),
          QrImageView(
            data: widget.address,
            version: QrVersions.auto,
            size: getScreenWidth(context) * 0.6,
          ),
          SizedBox(
          width: getScreenWidth(context) * 0.6,
          child: Text(
            'Scan this QR code from a different app to receive payments.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.03, color: black2),
          ),
        ),
         SizedBox(height: getScreenheight(context) * 0.06),
        Text(
            'Or',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: getScreenWidth(context) * 0.05, color: black2),
          ),
        SecondaryButton(onPressed: (){}, text: 'Copy your public address.')
        ],
      ),
    );
  }
}

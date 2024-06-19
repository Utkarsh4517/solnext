import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/constants/shadows.dart';

class TransactionButtons extends StatefulWidget {
  final String file;
  final String text;
  final VoidCallback function;
  const TransactionButtons({super.key, required this.file, required this.function, required this.text});

  @override
  State<TransactionButtons> createState() => _TransactionButtonsState();
}

class _TransactionButtonsState extends State<TransactionButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context) * 0.235,
      height: getScreenWidth(context) * 0.235,
      decoration: BoxDecoration(color: Colors.white, boxShadow: boxShadow, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.all(getScreenWidth(context) * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [SvgPicture.asset("assets/svgs/${widget.file}.svg"), Text(widget.text, style: GoogleFonts.poppins(fontWeight: FontWeight.w500))],
      ),
    );
  }
}

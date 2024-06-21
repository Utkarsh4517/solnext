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
  double factor = 0.2;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          factor = 0.18;
        });
      },
      onTapUp: (details) {
        setState(() {
          factor = 0.2;
        });
        widget.function();
      },
      onTapCancel: () {
        setState(() {
          factor = 0.2;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: getScreenWidth(context) * factor,
        height: getScreenWidth(context) * factor,
        decoration: BoxDecoration(color: Colors.white, boxShadow: boxShadow, borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.all(getScreenWidth(context) * 0.025),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/svgs/${widget.file}.svg", width: 25, height: 25),
            Text(widget.text, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: getScreenWidth(context) * 0.032)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';

class ViewOptionsSheet extends StatefulWidget {
  final double initialSlippage;
  const ViewOptionsSheet({
    super.key,
    required this.initialSlippage,
  });

  @override
  State<ViewOptionsSheet> createState() => _ViewOptionsSheetState();
}

class _ViewOptionsSheetState extends State<ViewOptionsSheet> {
  @override
  void initState() {
    super.initState();
    slippage = widget.initialSlippage;
    _selectedSlippage = [
      slippage == 0.3,
      slippage == 0.5,
      slippage == 0.75,
      slippage == 1.0,
    ];
  }

  late double slippage;

  List<Widget> slippageOptions = <Widget>[Text('0.3%'), Text('0.5%'), Text('0.75%'), Text('0.1%')];
  late List<bool> _selectedSlippage;

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
              'Options applied while swapping your tokens',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: getScreenWidth(context) * 0.03,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: getScreenheight(context) * 0.05),
          Text(
            'Slippage Options - Transaction will revert if the price changes unfavorably by more than this percentage.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: getScreenWidth(context) * 0.025,
              color: Colors.white,
            ),
          ),
          ToggleButtons(
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selectedSlippage.length; i++) {
                  _selectedSlippage[i] = i == index;
                }
                slippage = [0.3, 0.5, 0.75, 1.0][index];
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.black,
            selectedColor: purple,
            fillColor: Colors.white,
            color: Colors.white,
            constraints: const BoxConstraints(
              minHeight: 30.0,
              minWidth: 75.0,
            ),
            isSelected: _selectedSlippage,
            children: slippageOptions,
            textStyle: TextStyle(fontWeight: FontWeight.w900),
            borderColor: Colors.black,
          ),
          SizedBox(
            width: getScreenWidth(context) * 0.8,
            child: PrimaryButton(
                onPressed: () async {
                  Navigator.pop(context, slippage);
                },
                text: 'Save Options'),
          ),
          SizedBox(
            width: getScreenWidth(context) * 0.8,
            child: Text(
              'Note: Solnext DEX based swap is coming soon, stay tuned.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: getScreenWidth(context) * 0.025,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: getScreenheight(context) * 0.02),
        ],
      ),
    );
  }
}

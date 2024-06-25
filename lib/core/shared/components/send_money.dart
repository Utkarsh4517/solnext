import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/utils/transaction_manager.dart';

class SendMoneySheet extends StatefulWidget {
  const SendMoneySheet({super.key});

  @override
  State<SendMoneySheet> createState() => _SendMoneySheetState();
}

class _SendMoneySheetState extends State<SendMoneySheet> {
  final _tokenAmountController = TextEditingController();
  final _receiverAddressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text('Send SOL', style: GoogleFonts.poppins(color: purple, fontWeight: FontWeight.w600, fontSize: getScreenWidth(context) * 0.08)),
              SizedBox(height: getScreenheight(context) * 0.05),
              MUIPrimaryInputField(hintText: 'Receiver\'s address', controller: _receiverAddressController, filledColor: Colors.grey.shade200),
              SizedBox(height: getScreenheight(context) * 0.02),
              MUIPrimaryInputField(hintText: 'SOL amount to transfer', controller: _tokenAmountController, filledColor: Colors.grey.shade200)
            ],
          ),
          PrimaryButton(
              onPressed: () async {
                try {
                  await TransactionManager.sendSol(receiverAddress: _receiverAddressController.text, amountInSol: double.parse(_tokenAmountController.text));
                  Navigator.pop(context);
                } catch (e) {}
              },
              text: 'Send SOL')
        ],
      ),
    );
  }
}

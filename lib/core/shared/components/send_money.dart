import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/utils/print_log.dart';
import 'package:solnext/core/utils/transaction_manager.dart';

class SendMoneySheet extends StatefulWidget {
  const SendMoneySheet({super.key});

  @override
  State<SendMoneySheet> createState() => _SendMoneySheetState();
}

class _SendMoneySheetState extends State<SendMoneySheet> with SingleTickerProviderStateMixin {
  final _tokenAmountController = TextEditingController();
  final _receiverAddressController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String currentState = '';

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
          SizedBox(height: getScreenheight(context) * 0.02),
          if (currentState == '')
            TabBar(
              controller: _tabController,
              onTap: (value) {
                setState(() {});
              },
              dividerColor: Color.fromARGB(255, 255, 255, 255),
              indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              tabs: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color.fromARGB(255, 240, 240, 240)),
                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05, vertical: getScreenWidth(context) * 0.02),
                  child: Text('Send SOL', style: GoogleFonts.poppins(color: _tabController.index == 0 ? purple : black2, fontWeight: FontWeight.w600)),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color.fromARGB(255, 240, 240, 240)),
                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05, vertical: getScreenWidth(context) * 0.02),
                  child: Text('Send USDC', style: GoogleFonts.poppins(color: _tabController.index == 1 ? purple : black2, fontWeight: FontWeight.w600)),
                ),
              ],
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              labelColor: purple,
              unselectedLabelColor: Colors.grey,
            ),
          SizedBox(height: getScreenheight(context) * 0.02),
          Container(
            height: getScreenheight(context) * 0.4,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSendTab('SOL'),
                _buildSendTab('USDC'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendTab(String tokenType) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: getScreenheight(context) * 0.015),
        if (currentState == '')
          MUIPrimaryInputField(
            hintText: 'Receiver\'s address',
            controller: _receiverAddressController,
            filledColor: Color.fromARGB(255, 240, 240, 240),
            disabledBorderColor: Colors.white,
            enabledBorderColor: Colors.white,
          ),
        if (currentState == '') SizedBox(height: getScreenheight(context) * 0.02),
        if (currentState == '')
          MUIPrimaryInputField(
            hintText: '$tokenType amount to transfer',
            controller: _tokenAmountController,
            filledColor: Color.fromARGB(255, 240, 240, 240),
            disabledBorderColor: Colors.white,
            enabledBorderColor: Colors.white,
          ),
        if (currentState == '') SizedBox(height: getScreenheight(context) * 0.02),
        if (currentState == '')
          PrimaryButton(
              onPressed: () async {
                try {
                  if (tokenType == 'SOL') {
                    setState(() {
                      currentState = 'loading';
                    });
                    await TransactionManager.sendSol(receiverAddress: _receiverAddressController.text, amountInSol: double.parse(_tokenAmountController.text));
                    setState(() {
                      currentState = 'success';
                    });
                  } else if (tokenType == 'USDC') {
                    setState(() {
                      currentState = 'loading';
                    });
                    await TransactionManager.sendUsdc(receiverAddress: _receiverAddressController.text, amountInUsdc: double.parse(_tokenAmountController.text));
                    setState(() {
                      currentState = 'success';
                    });
                  }
                } catch (e) {
                  setState(() {
                    currentState = 'Error';
                  });
                }
              },
              text: 'Send $tokenType'),
        if (currentState == 'loading')
          Container(
            child: Lottie.asset('assets/svgs/loading_sol.json', width: 200, height: 200),
          ),
        if (currentState == 'success')
          Container(
            child: Lottie.asset('assets/svgs/success.json', width: 200, height: 200),
          ),
        if (currentState == 'error')
          Container(
            child: Lottie.asset('assets/svgs/error.json', width: 200, height: 200),
          ),
        if (currentState != '' && currentState != 'loading')
          PrimaryButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Close')
      ],
    );
  }
}

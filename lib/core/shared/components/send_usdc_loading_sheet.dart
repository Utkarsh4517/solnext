import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';
import 'package:solnext/core/utils/transaction_manager.dart';

class SendUsdcLoadingSheet extends StatefulWidget {
  final String receiverAddress;
  final double amountInUsdc;
  const SendUsdcLoadingSheet({
    super.key,
    required this.receiverAddress,
    required this.amountInUsdc,
  });

  @override
  State<SendUsdcLoadingSheet> createState() => _SendSolLoadingSheetState();
}

enum SendTransactionState { loading, success, error, none }

class _SendSolLoadingSheetState extends State<SendUsdcLoadingSheet> {
  SendTransactionState currentState = SendTransactionState.loading;
  String transactionHash = '';

  @override
  void initState() {
    super.initState();
    send();
  }

  send() async {
    try {
      final sign = await TransactionManager.sendUsdc(receiverAddress: widget.receiverAddress, amountInUsdc: widget.amountInUsdc);
      setState(() {
        currentState = SendTransactionState.success;
        transactionHash = sign;
      });
    } catch (e) {
      setState(() {
        currentState = SendTransactionState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff191628), Color(0xff715aff)],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
        ),
        width: getScreenWidth(context),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: getScreenheight(context) * 0.06),
              if (currentState == SendTransactionState.loading) Lottie.asset('assets/svgs/loading_sol.json'),
              if (currentState == SendTransactionState.success)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/svgs/Verified.json'),
                    SecondaryButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: transactionHash));
                      },
                      text: 'Copy Transaction Hash',
                    ),
                    PrimaryButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Done'),
                  ],
                ),
              if (currentState == SendTransactionState.error)
                Column(
                  children: [
                    Lottie.asset('assets/svgs/error.json'),
                    PrimaryButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Close'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

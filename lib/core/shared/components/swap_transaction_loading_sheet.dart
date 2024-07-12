import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';
import 'package:solnext/core/utils/jupiter.dart';

class SwapTransactionLoadingSheet extends StatefulWidget {
  final String userPublicKey;
  const SwapTransactionLoadingSheet({
    super.key,
    required this.userPublicKey,
  });

  @override
  State<SwapTransactionLoadingSheet> createState() => _SwapTransactionLoadingSheetState();
}

enum SwapTransactionState { loading, success, error, none }

class _SwapTransactionLoadingSheetState extends State<SwapTransactionLoadingSheet> {
  SwapTransactionState currentState = SwapTransactionState.loading;
  String transactionHash = '';

  @override
  void initState() {
    super.initState();
    swap();
  }

  swap() async {
    try {
      final res = await Jupiter.swapSolToUsdc(userPublicKey: widget.userPublicKey);
      setState(() {
        currentState = SwapTransactionState.success;
        transactionHash = res['swapTransaction'];
      });
    } catch (e) {
      setState(() {
        currentState = SwapTransactionState.error;
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
              if (currentState == SwapTransactionState.loading) Lottie.asset('assets/svgs/loading_sol.json'),
              if (currentState == SwapTransactionState.success)
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
              if (currentState == SwapTransactionState.error)
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

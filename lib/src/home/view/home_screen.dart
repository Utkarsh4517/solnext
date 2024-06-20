import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/animated_price_text_widget.dart';
import 'package:solnext/core/shared/components/custom_shimmer_animation.dart';
import 'package:solnext/core/shared/components/scan_a_qr_button.dart';
import 'package:solnext/core/utils/wallet.dart';
import 'package:solnext/src/home/data/wallet.dart';
import 'package:solnext/src/home/view/widgets/horizontal_token_card.dart';
import 'package:solnext/src/home/view/widgets/transaction_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<String>? _currentBalanceInUSDC;
  Timer? _timer;
  bool _isFirstLoad = true;
  String _priceInUsd = '';
  String _priceInSol = '';

  Future<String> fetchBalanceInUSDC() async {
    final pubAdd = await WalletService.getPublicKey();
    final currentBalanceInSol = await Wallet.getBalance(pubAdd);
    setState(() {
      _priceInSol = currentBalanceInSol.toString();
    });
    final conversionRate = await Wallet.getSolToUsdcConversionRate();
    final currentBalanceInUSDC = currentBalanceInSol * conversionRate;
    setState(() {
      _priceInUsd = currentBalanceInUSDC.toStringAsFixed(2);
    });
    return currentBalanceInUSDC.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _loadBalance();
    });
  }

  void _loadBalance() {
    setState(() {
      _currentBalanceInUSDC = fetchBalanceInUSDC();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Container(margin: EdgeInsets.only(right: getScreenWidth(context) * 0.05), child: SvgPicture.asset('assets/svgs/settings.svg')),
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: ScanAQrButton(),
        body: Stack(
          children: [
            Positioned(
              bottom: getScreenheight(context) * 0.1,
              child: Container(
                width: getScreenWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TransactionButtons(file: 'receive_solnext', function: () {}, text: 'Receive'),
                    TransactionButtons(file: 'send_solnext', function: () {}, text: 'Send'),
                    TransactionButtons(file: 'buy_solnext', function: () {}, text: 'Buy')
                  ],
                ),
              ),
            ),
            Positioned(
              top: getScreenheight(context) * 0.2,
              child: HorizontalTokenCard(priceInUsd: _priceInUsd, priceInSol: _priceInSol),
            ),
            Positioned(
              top: getScreenheight(context) * 0.01,
              child: FutureBuilder<String>(
                future: _currentBalanceInUSDC,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && _isFirstLoad) {
                    return SizedBox(
                      width: getScreenWidth(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomShimmerAnimation(),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.hasData) {
                    _isFirstLoad = false;
                    final balanceInUsd = snapshot.data!;
                    return AnimatedPriceTextWidget(balanceInUsd: balanceInUsd);
                  }
                  return Container();
                },
              ),
            )
          ],
        ));
  }
}

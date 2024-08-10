import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/animated_price_text_widget.dart';
import 'package:solnext/core/shared/components/buy_sheet.dart';
import 'package:solnext/core/shared/components/custom_shimmer_animation.dart';
import 'package:solnext/core/shared/components/receive_sheet.dart';
import 'package:solnext/core/shared/components/reveal_keypairs_sheet.dart';
import 'package:solnext/core/shared/components/scan_screen.dart';
import 'package:solnext/core/shared/components/swap_button.dart';
import 'package:solnext/core/shared/components/swap_sheet.dart';
import 'package:solnext/core/shared/components/token_to_send_sheet.dart';
import 'package:solnext/core/utils/tracker.dart';
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
  String _priceOfSolInUsd = '';
  String _priceInSol = '';
  String _priceInUsdc = '';
  String _priceOfUsdcinUsd = '';
  String _profitOrLoss = '';
  String _profitOrLossPercentage = '';
  String _profitOrLossSol = '';
  String _profitOrLossUsdc = '';
  String _profitOrLossSolPercentage = '';
  String _profitOrLossUsdcPercentage = '';
  String _publicAddress = '';

  @override
  void initState() {
    super.initState();
    _loadBalance();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _loadBalance();
    });
  }

  bool _areAllValuesLoaded() {
    return _priceInSol.isNotEmpty &&
        _priceOfSolInUsd.isNotEmpty &&
        _priceInUsdc.isNotEmpty &&
        _priceOfUsdcinUsd.isNotEmpty &&
        _profitOrLoss.isNotEmpty &&
        _profitOrLossPercentage.isNotEmpty &&
        _profitOrLossSol.isNotEmpty &&
        _profitOrLossUsdc.isNotEmpty &&
        _profitOrLossSolPercentage.isNotEmpty &&
        _profitOrLossUsdcPercentage.isNotEmpty &&
        _publicAddress.isNotEmpty;
  }

  void _loadBalance() async {
    final balance = await Tracker.fetchBalance();
    setState(() {
      _currentBalanceInUSDC = Future.value(balance.currentValue);
      _priceInSol = balance.priceInSol;
      _priceOfSolInUsd = balance.priceOfSolInUsd;
      _priceInUsdc = balance.priceInUsdc;
      _priceOfUsdcinUsd = balance.priceOfUsdcInUsd;
      _profitOrLoss = balance.profitOrLoss;
      _profitOrLossPercentage = balance.profitOrLossPercentage;
      _profitOrLossSol = balance.profitOrLossSol;
      _profitOrLossUsdc = balance.profitOrLossUsdc;
      _profitOrLossSolPercentage = balance.profitOrLossSolPercentage;
      _profitOrLossUsdcPercentage = balance.profitOrLossUsdcPercentage;
      _publicAddress = balance.publicAddress;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  showReceiveSheet(BuildContext context, String address) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25.0),
              bottom: Radius.circular(25.0),
            ),
            child: ReceiveSheet(address: address),
          ),
        );
      },
    );
  }

  showTokenToSendSheet(BuildContext context, HorizontalTokenCard solana, HorizontalTokenCard usdc) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25.0),
              bottom: Radius.circular(25.0),
            ),
            child: TokenToSendSheet(solana: solana, usdc: usdc),
          ),
        );
      },
    );
  }

  showBuySheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: BuySheet(),
        );
      },
    );
  }

  showSwapSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 10, right: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25.0),
              bottom: Radius.circular(25.0),
            ),
            child: SwapSheet(),
          ),
        );
      },
    );
  }

    showRevealKeypairSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 10, right: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25.0),
              bottom: Radius.circular(25.0),
            ),
            child: RevealKeypairsSheet(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      body: _areAllValuesLoaded()
          ? _buildHomeContent()
          : Scaffold(
              body: Container(
                width: getScreenWidth(context),
                height: getScreenheight(context),
                decoration: BoxDecoration(gradient: gradient),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        Positioned(
          top: getScreenheight(context) * 0.33,
          child: Container(
            width: getScreenWidth(context),
            height: getScreenheight(context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [Color(0xff191628), Color(0xff715aff)],
                  stops: [0, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
          ),
        ),
        Positioned(
            bottom: getScreenheight(context) * 0.22,
            child: GestureDetector(
              onTap: () {
                showRevealKeypairSheet(context);
              },
              child: Container(
                width: getScreenWidth(context),
                alignment: Alignment.center,
                child: Text(
                  'View Keypairs',
                  style: GoogleFonts.poppins(
                    color: purple,
                    fontWeight: FontWeight.w500,
                    fontSize: getScreenWidth(context) * 0.04,
                  ),
                ),
              ),
            )),
        Positioned(
          top: getScreenheight(context) * 0.36,
          left: getScreenWidth(context) * 0.05,
          child: Container(
            width: getScreenWidth(context) * 0.9,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TransactionButtons(
                    file: 'Receive',
                    function: () {
                      showReceiveSheet(context, _publicAddress);
                    },
                    text: 'Receive'),
                TransactionButtons(
                    file: 'Send',
                    function: () {
                      showTokenToSendSheet(
                        context,
                        HorizontalTokenCard(
                          priceInUsd: _priceOfSolInUsd,
                          price: _priceInSol,
                          changeInPriceInUsd: _profitOrLossSol,
                          tokenName: 'SOL',
                          tokenCurrencyName: 'Solana',
                          imgPath: 'solana',
                        ),
                        HorizontalTokenCard(
                          priceInUsd: _priceOfUsdcinUsd,
                          price: _priceInUsdc,
                          changeInPriceInUsd: _profitOrLossUsdc,
                          tokenName: 'USDC',
                          tokenCurrencyName: 'USD Coin',
                          imgPath: 'usdCoin',
                        ),
                      );
                    },
                    text: 'Send'),
                TransactionButtons(
                    file: 'scan',
                    function: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => QRScannerScreen()));
                    },
                    text: 'Scan'),
              ],
            ),
          ),
        ),
        Positioned(
          top: getScreenheight(context) * 0.48,
          child: HorizontalTokenCard(
            priceInUsd: _priceOfSolInUsd,
            price: _priceInSol,
            changeInPriceInUsd: _profitOrLossSol,
            tokenName: 'SOL',
            tokenCurrencyName: 'Solana',
            imgPath: 'solana',
          ),
        ),
        Positioned(
          top: getScreenheight(context) * 0.6,
          child: HorizontalTokenCard(
            priceInUsd: _priceOfUsdcinUsd,
            price: _priceInUsdc,
            changeInPriceInUsd: _profitOrLossUsdc,
            tokenName: 'USDC',
            tokenCurrencyName: 'USD Coin',
            imgPath: 'usdCoin',
          ),
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: getScreenheight(context) * 0.1),
                    AnimatedPriceTextWidget(balanceInUsd: balanceInUsd),
                    Row(
                      children: [
                        Text(
                          '${(double.tryParse(_profitOrLoss) ?? 0) < 0 ? "-\$${((double.tryParse(_profitOrLoss) ?? 0) * -1).toStringAsFixed(2)}" : "+\$${(double.tryParse(_profitOrLoss) ?? 0).toStringAsFixed(2)}"}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: (double.tryParse(_profitOrLoss) ?? 0) > 0 ? green : red, fontSize: getScreenWidth(context) * 0.06),
                        ),
                        SizedBox(width: getScreenWidth(context) * 0.03),
                        Container(
                          alignment: Alignment.center,
                          width: getScreenWidth(context) * 0.16,
                          padding: EdgeInsets.symmetric(vertical: getScreenWidth(context) * 0.02),
                          decoration: BoxDecoration(color: (double.tryParse(_profitOrLossPercentage) ?? 0) > 0 ? greenAccent : redAccent, borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '${(double.tryParse(_profitOrLossPercentage) ?? 0) < 0 ? "${((double.tryParse(_profitOrLossPercentage) ?? 0) * -1).toStringAsFixed(2)}%" : "${(double.tryParse(_profitOrLossPercentage) ?? 0).toStringAsFixed(2)}%"}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: (double.tryParse(_profitOrLossPercentage) ?? 0) > 0 ? green : red, fontSize: getScreenWidth(context) * 0.03),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showSwapSheet(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: getScreenWidth(context) * 0.3, top: getScreenheight(context) * 0.01),
                        alignment: Alignment.center,
                        child: SwapButton(),
                      ),
                    )
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}

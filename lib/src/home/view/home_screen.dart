import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/models/transaction.dart';
import 'package:solnext/core/shared/components/animated_price_text_widget.dart';
import 'package:solnext/core/shared/components/custom_shimmer_animation.dart';
import 'package:solnext/core/utils/print_log.dart';
import 'package:solnext/core/utils/transaction_details.dart';
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
  String _profitOrLoss = '';
  String _profitOrLossPercentage = '';

  Future<String> fetchBalanceInUSDC() async {
    final pubAdd = await WalletService.getPublicKey();
    final currentBalanceInSol = await Wallet.getBalance(pubAdd);
    final previousBalanceInSol = await TransactionManager.getPreviousBalance();
    // Check for new deposits
    if (currentBalanceInSol > previousBalanceInSol) {
      final newDeposit = currentBalanceInSol - previousBalanceInSol;
      // Fetch the current price of SOL
      final currentPrice = await Wallet.getSolToUsdcConversionRate();
      final newTransaction = TransactionDTO(amount: newDeposit, price: currentPrice);
      await TransactionManager.saveTransaction(newTransaction);
      // Update the previous balance
      await TransactionManager.savePreviousBalance(currentBalanceInSol);
    }
    // Update the SOL balance state
    setState(() {
      _priceInSol = currentBalanceInSol.toString();
    });

    // Fetch the conversion rate from SOL to USDC
    final conversionRate = await Wallet.getSolToUsdcConversionRate();

    // Calculate the current balance in USDC
    final currentBalanceInUSDC = currentBalanceInSol * conversionRate;

    // Update the USDC balance state
    setState(() {
      _priceInUsd = currentBalanceInUSDC.toStringAsFixed(2);
    });

    // Fetch the transaction history
    final transactions = await TransactionManager.getTransactions();

    double totalInvestment = 0.0;
    double totalSolBought = 0.0;
    double totalSolSold = 0.0;

    // Process each transaction to calculate the total investment, total SOL bought, and total SOL sold
    for (var transaction in transactions) {
      if (transaction.amount > 0) {
        // Buy transaction
        totalInvestment += transaction.amount * transaction.price;
        totalSolBought += transaction.amount;
      } else {
        // Sell transaction
        totalSolSold += transaction.amount.abs();
        totalInvestment -= transaction.amount.abs() * transaction.price;
      }
    }

    // Calculate net holdings and the current value
    final netHoldings = totalSolBought - totalSolSold;
    final currentValue = netHoldings * conversionRate;

    // Calculate profit or loss and the percentage
    final profitOrLoss = currentValue - totalInvestment;
    final profitOrLossPercentage = (totalInvestment != 0) ? (profitOrLoss / totalInvestment) * 100 : 0.0;

    // Update the profit or loss states (if required)
    setState(() {
      _profitOrLoss = profitOrLoss.toStringAsFixed(2);
      _profitOrLossPercentage = profitOrLossPercentage.toStringAsFixed(2);
    });

    PrintLog.printLog(_profitOrLoss);

    // Return the current value of the investment in USD
    return currentValue.toStringAsFixed(2);
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
          Container(
            margin: EdgeInsets.only(right: getScreenWidth(context) * 0.05),
            child: SvgPicture.asset('assets/svgs/settings.svg'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      // floatingActionButton: ScanAQrButton(),
      body: Stack(
        children: [
          Positioned(
            bottom: getScreenheight(context) * 0.02,
            left: getScreenWidth(context) * 0.05,
            child: Container(
              width: getScreenWidth(context) * 0.9,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TransactionButtons(file: 'receive_solnext', function: () {}, text: 'Receive'),
                  TransactionButtons(file: 'send_solnext', function: () {}, text: 'Send'),
                  TransactionButtons(file: 'buy_solnext', function: () {}, text: 'Buy'),
                ],
              ),
            ),
          ),
          Positioned(
            top: getScreenheight(context) * 0.2,
            child: HorizontalTokenCard(priceInUsd: _priceInUsd, priceInSol: _priceInSol, changeInPriceInUsd: _profitOrLoss),
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
                    children: [
                      AnimatedPriceTextWidget(balanceInUsd: balanceInUsd),
                      Row(
                        children: [
                          Text(
                            '${double.parse(_profitOrLoss) < 0 ? "-\$${(double.parse(_profitOrLoss) * -1)}" : "+\$${_profitOrLoss}"}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: double.parse(_profitOrLoss) > 0 ? green : red, fontSize: getScreenWidth(context) * 0.06),
                          ),
                          SizedBox(width: getScreenWidth(context) * 0.03),
                          Container(
                            padding: EdgeInsets.all(getScreenWidth(context) * 0.025),
                            decoration: BoxDecoration(
                              color: double.parse(_profitOrLossPercentage) >0 ? greenAccent : redAccent,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                             '${double.parse(_profitOrLossPercentage) < 0 ? "${(double.parse(_profitOrLossPercentage) * -1)}%" : "${_profitOrLossPercentage}%"}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: double.parse(_profitOrLossPercentage) > 0 ? green : red, fontSize: getScreenWidth(context) * 0.03),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/models/transactionDTO.dart';
import 'package:solnext/core/shared/components/animated_price_text_widget.dart';
import 'package:solnext/core/shared/components/custom_shimmer_animation.dart';
import 'package:solnext/core/shared/components/receive_sheet.dart';
import 'package:solnext/core/shared/components/send_money.dart';
import 'package:solnext/core/shared/components/swap_button.dart';
import 'package:solnext/core/utils/print_log.dart';
import 'package:solnext/core/utils/transaction_manager.dart';
import 'package:solnext/core/utils/wallet_service.dart';
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
  String _priceOfSolInUsd = '';
  String _priceInSol = '';
  String _priceInUsdc = '';
  String _priceOfUsdcinUsd = '';
  String _profitOrLoss = '';
  String _profitOrLossPercentage = '';
  String _publicAddress = '';

  Future<String> fetchBalanceInUSDC() async {
    final pubAdd = await WalletService.getPublicKey();
    PrintLog.printLog(pubAdd);
    final usdcMintAddress = '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU';
    setState(() {
      _publicAddress = pubAdd;
    });

    /// FOR SOL
    final currentBalanceInSol = await Wallet.getBalance(pubAdd);
    final previousBalanceInSol = await TransactionManager.getSOLPreviousBalance();
    // Check for new SOL deposits
    if (currentBalanceInSol > previousBalanceInSol) {
      final newDeposit = currentBalanceInSol - previousBalanceInSol;
      // Fetch the current price of SOL
      final currentPriceSolToUsd = await Wallet.getSolToUsdcConversionRate();
      final newTransaction = TransactionDtoSol(amount: newDeposit, price: currentPriceSolToUsd);
      await TransactionManager.saveSolTransaction(newTransaction);
      await TransactionManager.saveSOLPreviousBalance(currentBalanceInSol);
    }
    setState(() {
      _priceInSol = currentBalanceInSol.toString();
    });
    final conversionRateSolToUsd = await Wallet.getSolToUsdcConversionRate();
    final currentBalanceOfSolInUSD = currentBalanceInSol * conversionRateSolToUsd;
    setState(() {
      _priceOfSolInUsd = currentBalanceOfSolInUSD.toStringAsFixed(2);
    });

    /// FOR USDC
    final currentBalanceInUsdc = await Wallet.getTokenBalance(pubAdd, usdcMintAddress);
    PrintLog.printLog('current balance in usdc $currentBalanceInUsdc');
    final previousBalanceInUsdc = await TransactionManager.getUSDCPreviousBalance();
    // check for new USDC deposits
    if (currentBalanceInUsdc > previousBalanceInUsdc) {
      final newDeposit = currentBalanceInUsdc - previousBalanceInUsdc;
      final currentPriceUsdcToUsd = await Wallet.getUsdcToUsdConversionRate();
      final newTransaction = TransactionDtoUsdc(amount: newDeposit, price: currentPriceUsdcToUsd);
      await TransactionManager.saveUsdcTransaction(newTransaction);
      await TransactionManager.saveUSDCPreviousBalance(currentBalanceInUsdc);
    }

    setState(() {
      _priceInUsdc = currentBalanceInUsdc.toString();
    });
    final conversionRateUsdcToUsd = await Wallet.getUsdcToUsdConversionRate();
    final currentBalanceOfUsdcInUsd = currentBalanceInUsdc * conversionRateUsdcToUsd;
    setState(() {
      _priceOfUsdcinUsd = currentBalanceOfUsdcInUsd.toStringAsFixed(2);
    });

    double totalInvestment = 0.0; // total investment in SOL + USDC
    double totalSolBought = 0.0;
    double totalSolSold = 0.0;
    double totalUsdcBought = 0.0;
    double totalUsdcSold = 0.0;

    // Fetch the transaction history for SOL
    final solTransactions = await TransactionManager.getSolTransactions();
    // Process each transaction to calculate the total investment, total SOL bought, and total SOL sold
    for (var transaction in solTransactions) {
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

    // fetch the transaction history for USDC
    final usdcTransactions = await TransactionManager.getUsdcTransactions();
    // Process each transaction to calculate the total investment, total USDC bought, and total USDC sold
    for (var transaction in usdcTransactions) {
      if (transaction.amount > 0) {
        // Buy transaction
        totalInvestment += transaction.amount * transaction.price;
        totalUsdcBought += transaction.amount;
      } else {
        // Sell transaction
        totalInvestment -= transaction.amount.abs() * transaction.price;
        totalUsdcSold += transaction.amount.abs();
      }
    }

    // Calculate net holdings and the current value
    final netSolHoldings = totalSolBought - totalSolSold;
    final netUsdcHoldings = totalUsdcBought - totalUsdcSold;
    final currentValue = (netSolHoldings * conversionRateSolToUsd) + (netUsdcHoldings * conversionRateUsdcToUsd);

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

  showReceiveSheet(BuildContext context, String address) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) {
        return ReceiveSheet(address: address);
      },
    );
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
                  TransactionButtons(
                      file: 'receive_solnext',
                      function: () {
                        showReceiveSheet(context, _publicAddress);
                      },
                      text: 'Receive'),
                  TransactionButtons(
                      file: 'send_solnext',
                      function: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SendMoneySheet()));
                      },
                      text: 'Send'),
                  TransactionButtons(file: 'buy_solnext', function: () {}, text: 'Buy'),
                ],
              ),
            ),
          ),
          Positioned(
            top: getScreenheight(context) * 0.22,
            child: HorizontalTokenCard(
              priceInUsd: _priceOfSolInUsd,
              priceInSol: _priceInSol,
              changeInPriceInUsd: _profitOrLoss,
              tokenName: 'SOL',
              tokenCurrencyName: 'Solana',
              imgPath: 'SOLANA',
            ),
          ),
          Positioned(
            top: getScreenheight(context) * 0.34,
            child: HorizontalTokenCard(
              priceInUsd: _priceOfUsdcinUsd,
              priceInSol: _priceInUsdc,
              changeInPriceInUsd: _profitOrLoss,
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
                      AnimatedPriceTextWidget(balanceInUsd: balanceInUsd),
                      Row(
                        children: [
                          Text(
                            '${double.parse(_profitOrLoss) < 0 ? "-\$${(double.parse(_profitOrLoss) * -1)}" : "+\$${_profitOrLoss}"}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: double.parse(_profitOrLoss) > 0 ? green : red, fontSize: getScreenWidth(context) * 0.06),
                          ),
                          SizedBox(width: getScreenWidth(context) * 0.03),
                          Container(
                            alignment: Alignment.center,
                            width: getScreenWidth(context) * 0.16,
                            padding: EdgeInsets.symmetric(vertical: getScreenWidth(context) * 0.02),
                            decoration: BoxDecoration(color: double.parse(_profitOrLossPercentage) > 0 ? greenAccent : redAccent, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '${double.parse(_profitOrLossPercentage) < 0 ? "${(double.parse(_profitOrLossPercentage) * -1)}%" : "${_profitOrLossPercentage}%"}',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: double.parse(_profitOrLossPercentage) > 0 ? green : red, fontSize: getScreenWidth(context) * 0.03),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: getScreenWidth(context) * 0.3, top: getScreenheight(context) * 0.01),
                        alignment: Alignment.center,
                        child: SwapButton(),
                      )
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

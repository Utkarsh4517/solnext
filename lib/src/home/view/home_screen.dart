import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/scan_a_qr_button.dart';
import 'package:solnext/core/utils/print_log.dart';
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

  Future<String> fetchBalanceInUSDC() async {
    final pubAdd = await WalletService.getPublicKey();
    final currentBalanceInSol = await Wallet.getBalance(pubAdd);
    final conversionRate = await Wallet.getSolToUsdcConversionRate();
    final currentBalanceInUSDC = currentBalanceInSol * conversionRate;
    return currentBalanceInUSDC.toString();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentBalanceInUSDC = fetchBalanceInUSDC();
    });
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
              child: HorizontalTokenCard(),
            ),
            Positioned(
              top: getScreenheight(context) * 0.1,
              child: FutureBuilder(
                future: _currentBalanceInUSDC,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.hasData) {
                    final pubAdd = snapshot.data!;
                    PrintLog.printLog(pubAdd);
                    return Text(pubAdd);
                  }
                  return Container();
                },
              ),
            )
          ],
        ));
  }
}

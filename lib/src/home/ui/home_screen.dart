import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/scan_a_qr_button.dart';
import 'package:solnext/src/home/widgets/horizontal_token_card.dart';
import 'package:solnext/src/home/widgets/transaction_buttons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            )
          ],
        ));
  }
}

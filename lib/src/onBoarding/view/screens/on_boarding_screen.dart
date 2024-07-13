// ignore_for_file: use_build_context_synchronously

import 'package:solana/solana.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/import_wallet_sheet.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/components/secondary_button.dart';
import 'package:solnext/src/onBoarding/view/screens/intro_page2.dart';
import 'package:solnext/src/onBoarding/view/screens/intro_page3.dart';
import 'package:solnext/src/onBoarding/view/screens/intro_page1.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;
  int currentIndex = 0;
  final SolanaClient client = SolanaClient(rpcUrl: Uri(), websocketUrl: Uri(), timeout: const Duration(seconds: 30));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                currentIndex = index;
              });
            },
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          if (currentIndex == 0)
            Positioned(
              bottom: getScreenheight(context) * 0.05,
              left: getScreenWidth(context) * 0.05,
              child: SizedBox(
                width: getScreenWidth(context) * 0.9,
                height: getScreenheight(context) * 0.055,
                child: PrimaryButton(
                    onPressed: () {
                      _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                    },
                    text: 'Get Started'),
              ),
            ),
          if (currentIndex == 1)
            Positioned(
              bottom: getScreenheight(context) * 0.05,
              left: getScreenWidth(context) * 0.05,
              child: SizedBox(
                width: getScreenWidth(context) * 0.9,
                height: getScreenheight(context) * 0.055,
                child: PrimaryButton(
                    onPressed: () {
                      // _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25.0),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10, left: 10, right: 10),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(25.0),
                                bottom: Radius.circular(25.0),
                              ),
                              child: ImportWalletSheet(),
                            ),
                          );
                        },
                      );
                    },
                    text: 'Import a wallet'),
              ),
            ),
          if (currentIndex == 1)
            Positioned(
              bottom: getScreenheight(context) * 0.12,
              left: getScreenWidth(context) * 0.05,
              child: SizedBox(
                width: getScreenWidth(context) * 0.9,
                height: getScreenheight(context) * 0.055,
                child: SecondaryButton(
                    onPressed: () async {
                      _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                      // PrintLog.printLog(pubkey);
                      // PrintLog.printLog(privateKey);
                    },
                    text: 'Create a new wallet'),
              ),
            ),
        ],
      ),
    );
  }
}

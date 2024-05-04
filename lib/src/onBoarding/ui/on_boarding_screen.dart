// ignore_for_file: use_build_context_synchronously

import 'package:google_fonts/google_fonts.dart';
import 'package:solnext/core/constants/colors.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/core/shared/components/primary_button.dart';
import 'package:solnext/core/shared/nav_bar.dart';
import 'package:solnext/src/onBoarding/ui/intro_page2.dart';
import 'package:solnext/src/onBoarding/ui/intro_page3.dart';
import 'package:solnext/src/onBoarding/ui/intro_page1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool onLastPage = false;
  int currentIndex = 0;

  void _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationScreen()));
  }

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
          if(currentIndex == 0)
          Positioned(
            bottom: getScreenheight(context) * 0.05,
            left: getScreenWidth(context) * 0.05,
            child: SizedBox(
              width: getScreenWidth(context) * 0.9,
              height: getScreenheight(context) * 0.055,
              child: PrimaryButton(onPressed: () {
                 _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
              }, text: 'Get Started'),
            ),
          ),
          
        ],
      ),
    );
  }
}

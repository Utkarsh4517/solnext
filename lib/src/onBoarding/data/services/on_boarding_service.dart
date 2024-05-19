// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solnext/core/shared/nav_bar.dart';

class OnBoardingService {
  static void completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenOnboarding', true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationScreen()));
  }
}

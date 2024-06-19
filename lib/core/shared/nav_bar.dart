// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solnext/core/constants/dimensions.dart';
import 'package:solnext/src/home/ui/home_screen.dart';
import 'package:solnext/src/nft/ui/nft_screen.dart';
import 'package:solnext/src/marketplace/ui/marketplace_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedTab = 0;

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  List _pages = [
    HomeScreen(),
    NftScreen(),
    MarketplaceScreen(),
  ];

  Widget _buildNavItem(String asset, int index) {
    final color = _selectedTab == index ? Color(0xFF715AFF) : Color(0xFF838383);
    return SvgPicture.asset(asset, width: 30, height: 30, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(0, 200, 200, 200).withOpacity(1),
              offset: Offset(0, -5),
              blurRadius: 22,
              spreadRadius: -2,
            )
          ],
        ),
        margin: EdgeInsets.all(getScreenWidth(context) * 0.05),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 10,
            currentIndex: _selectedTab,
            onTap: (index) {
              _changeTab(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: _buildNavItem('assets/svgs/home_solnext1.svg', 0),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem('assets/svgs/nft.svg', 1),
                label: 'nft',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem('assets/svgs/marketplace.svg', 2),
                label: 'marketplace',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedTab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
            color: Color.fromARGB(0, 200, 200, 200).withOpacity(1),
            offset: Offset(0, -5),
            blurRadius: 22,
            spreadRadius: -2,
          )
        ]),
        margin: EdgeInsets.all(getScreenWidth(context) * 0.05),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            elevation: 10,
            currentIndex: _selectedTab,
            onTap: (index) {
              _changeTab(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'nft'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'marketplace'),
            ],
          ),
        ),
      ),
    );
  }
}

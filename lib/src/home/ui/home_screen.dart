import 'package:flutter/material.dart';
import 'package:solnext/core/shared/components/scan_a_qr_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScanAQrButton(),
      body: Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}

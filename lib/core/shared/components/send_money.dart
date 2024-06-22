import 'package:flutter/material.dart';

class SendMoneySheet extends StatefulWidget {
  const SendMoneySheet({super.key});

  @override
  State<SendMoneySheet> createState() => _SendMoneySheetState();
}

class _SendMoneySheetState extends State<SendMoneySheet> {
  final _tokenAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _tokenAmountController,
              decoration: InputDecoration(
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:solana_web3/solana_web3.dart' as web3;

class CreateWallet {
  static Future<(String, String)> createWallet() async {
    // final cluster = web3.Cluster.devnet;
    // final connection = web3.Connection(cluster);
    final wallet = web3.Keypair.generateSync();

    String pubkey = wallet.pubkey.toString();
    Uint8List secretKeyUint8List = Uint8List.fromList(wallet.seckey);
    String base64EncodedKey = base64Encode(secretKeyUint8List);
    return (pubkey, base64EncodedKey);
  }
}

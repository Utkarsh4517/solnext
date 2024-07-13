import 'dart:typed_data';

import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:solnext/core/utils/wallet_service.dart';

class CreateWallet {
  static Future<(Ed25519HDKeyPair, String)> createNewWallet() async {
    final String mnemonic = bip39.generateMnemonic();
    await WalletService.saveMnemonics(mnemonics: mnemonic);
    final Ed25519HDKeyPair keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
    return (keypair, mnemonic);
  }

  static Future<Ed25519HDKeyPair> generateWalletFromMnemonic(String mnemonic) async {
    final Ed25519HDKeyPair keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
    await WalletService.saveMnemonics(mnemonics: mnemonic);
    return keypair;
  }

  static Future<Ed25519HDKeyPair> generateWalletFromPrivateKey(String privateKeyHex) async {
    final List<int> privateKeyBytes = Uint8List.fromList(
      List<int>.generate(
        privateKeyHex.length ~/ 2,
        (index) => int.parse(privateKeyHex.substring(index * 2, index * 2 + 2), radix: 16),
      ),
    );

    final Ed25519HDKeyPair keypair = await Ed25519HDKeyPair.fromPrivateKeyBytes(privateKey: privateKeyBytes);

    return keypair;
  }

  static Future<String> getPrivateKey(Ed25519HDKeyPair keypair) async {
    final privateKey = await keypair.extract();
    return privateKey.bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}

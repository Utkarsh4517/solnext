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
}

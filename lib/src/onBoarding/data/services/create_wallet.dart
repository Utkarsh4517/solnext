import 'package:solana/solana.dart';
import 'package:bip39/bip39.dart' as bip39;

class CreateWallet {
  static Future<(Ed25519HDKeyPair, String)> createNewWallet() async {
    final String mnemonic = bip39.generateMnemonic();
    final Ed25519HDKeyPair keypair = await Ed25519HDKeyPair.fromMnemonic(mnemonic);
    return (keypair, mnemonic);
  }
}

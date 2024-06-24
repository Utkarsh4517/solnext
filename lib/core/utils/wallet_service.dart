import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
  static Future<void> savePublicKey({required String publicKey}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('publicKey', publicKey);
  }

  static Future<String> getPublicKey() async {
    final prefs = await SharedPreferences.getInstance();
    String publicKey = prefs.getString('publicKey')!;
    return publicKey;
  }

  static Future<void> saveMnemonics({required String mnemonics}) async {
    final secureStorage = await FlutterSecureStorage();
    secureStorage.write(key: 'mnemonics', value: mnemonics);
  }

  static Future<String> getMnemonics() async {
    final secureStorage = await FlutterSecureStorage();
    String? mnemonics = await secureStorage.read(key: 'mnemonics');
    return mnemonics!;
  }
}

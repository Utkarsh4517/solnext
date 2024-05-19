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
}

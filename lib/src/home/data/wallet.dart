import 'package:solana/solana.dart';
import 'package:solnext/core/utils/print_log.dart';
import 'package:solnext/core/utils/solana.dart';

class Wallet {
  static Future<double> getBalance(String walletAddress) async {
    try {
      final lamports = await client.getBalance(walletAddress);
      final sol = lamports.value / lamportsPerSol;
      PrintLog.printLog(sol.toString());
      return sol;
    } catch (e) {
      print('Error fetching balance: $e');
      return 0.0;
    }
  }
}

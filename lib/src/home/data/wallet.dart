import 'dart:convert';
import 'dart:math';

import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solnext/core/utils/solana.dart';
import 'package:http/http.dart' as http;

class WalletHandler {
  static Future<double> getBalance(String walletAddress) async {
    try {
      final lamports = await client.getBalance(walletAddress);
      final sol = lamports.value / lamportsPerSol;
      return sol;
    } catch (e) {
      print('Error fetching balance: $e');
      return 0.0;
    }
  }

  static Future<double> getSolToUsdcConversionRate() async {
    final url = 'https://price.jup.ag/v4/price?ids=SOL&vs_currencies=USD';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final conversionRate = data['data']['SOL']['price'];
        final doubleRate = double.parse(conversionRate.toString());
        final formattedRate = doubleRate.toStringAsFixed(2);
        return double.parse(formattedRate);
      } else {
        throw Exception('Failed to load conversion rate');
      }
    } catch (e) {
      print('Error fetching conversion rate: $e');
      return 0.0;
    }
  }

  static Future<double> getTokenBalance(String walletAddress, String mintAddress) async {
 try {
      final response = await client.getTokenAccountsByOwner(
        walletAddress,
        TokenAccountsFilter.byMint(mintAddress),
        encoding: Encoding.base64
      );

      double totalBalance = 0.0;
      for (var account in response.value) {
        final accountInfo = await client.getTokenAccountBalance(account.pubkey);
        totalBalance += double.parse(accountInfo.value.amount) / pow(10, accountInfo.value.decimals);
      }

      return totalBalance;
    } catch (e) {
      print('Error fetching token balance: $e');
      return 0.0;
    }
  }

  static Future<double> getUsdcToUsdConversionRate() async {
    final url = 'https://price.jup.ag/v4/price?ids=USDC&vs_currencies=USD';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final conversionRate = data['data']['USDC']['price'];
        return double.parse(conversionRate.toString());
      } else {
        throw Exception('Failed to load conversion rate');
      }
    } catch (e) {
      print('Error fetching conversion rate: $e');
      return 0.0;
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solnext/core/utils/print_log.dart';

class Jupiter {
  static Map<String, dynamic> quoteResponse = {};

  static Future<double> getSolToUsdcQuote({required String amount, required String slippage}) async {
    String lamports = (double.parse(amount) * 1000000000).toStringAsFixed(0);
    String apiUrl =
        'https://quote-api.jup.ag/v6/quote?inputMint=So11111111111111111111111111111111111111112&outputMint=EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v&amount=$lamports&slippageBps=$slippage';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      final usdcAmount = jsonDecode(response.body)['outAmount'];
      final usdc = double.parse(usdcAmount) / 1000000;
      quoteResponse = jsonDecode(response.body);
      return usdc;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<dynamic> swapSolToUsdc({required String userPublicKey}) async {
    String apiUrl = 'https://quote-api.jup.ag/v6/swap';
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({"userPublicKey": userPublicKey, "quoteResponse": quoteResponse}));
      PrintLog.printLog(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

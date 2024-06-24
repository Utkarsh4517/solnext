import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solnext/core/models/transactionDTO.dart';
import 'package:solnext/core/utils/solana.dart';
import 'package:solnext/core/utils/wallet_service.dart';

class TransactionManager {
  static Future<void> saveSolTransaction(TransactionDtoSol transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_sol') ?? [];
    transactions.add(jsonEncode(transaction.toJson()));
    await prefs.setStringList('transactions_sol', transactions);
  }

  static Future<List<TransactionDtoSol>> getSolTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_sol') ?? [];
    return transactions.map((t) => TransactionDtoSol.fromJson(jsonDecode(t))).toList();
  }

  static Future<void> saveUsdcTransaction(TransactionDtoUsdc transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_usdc') ?? [];
    transactions.add(jsonEncode(transaction.toJson()));
    await prefs.setStringList('transactions_usdc', transactions);
  }

  static Future<List<TransactionDtoUsdc>> getUsdcTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_usdc') ?? [];
    return transactions.map((t) => TransactionDtoUsdc.fromJson(jsonDecode(t))).toList();
  }

  static Future<void> saveSOLPreviousBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('previousBalanceSOL', balance);
  }

  static Future<double> getSOLPreviousBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('previousBalanceSOL') ?? 0.0;
  }

  static Future<void> saveUSDCPreviousBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('previousBalanceUSDC', balance);
  }

  static Future<double> getUSDCPreviousBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('previousBalanceUSDC') ?? 0.0;
  }

  static Future<void> sendSol({required String receiverAddress, required double amountInSol}) async {
    final lamports = (amountInSol * 1e9).toInt();
    final senderPrivateMnemonics = await WalletService.getMnemonics();
    final senderKeypair = await Ed25519HDKeyPair.fromMnemonic(senderPrivateMnemonics);
    try {
      final transaction = Message(
        instructions: [
          SystemInstruction.transfer(
            fundingAccount: senderKeypair.publicKey,
            recipientAccount: Ed25519HDPublicKey.fromBase58(receiverAddress),
            lamports: lamports,
          ),
        ],
        //
      );
      final signature = await client.signAndSendTransaction(
        transaction,
        [senderKeypair],
      );
      print('Transaction sent! Signature: $signature');
    } catch (e) {
      print('Error sending SOL: $e');
    }
  }
}

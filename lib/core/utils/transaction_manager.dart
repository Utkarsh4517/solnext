import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solana/solana_pay.dart';
import 'package:solnext/core/models/transactionDTO.dart';
import 'package:solnext/core/utils/solana.dart';
import 'package:solnext/core/utils/wallet_service.dart';
import 'package:solnext/src/home/data/wallet.dart';

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

  static Future<void> saveSolOutgoingTransaction(TransactionDtoSol transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_sol_outgoing') ?? [];
    transactions.add(jsonEncode(transaction.toJson()));
    await prefs.setStringList('transactions_sol_outgoing', transactions);
  }

  static Future<List<TransactionDtoSol>> getSolOutgoingTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_sol_outgoing') ?? [];
    return transactions.map((t) => TransactionDtoSol.fromJson(jsonDecode(t))).toList();
  }

  static Future<void> saveUsdcOutgoingTransaction(TransactionDtoUsdc transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_usdc_outgoing') ?? [];
    transactions.add(jsonEncode(transaction.toJson()));
    await prefs.setStringList('transactions_usdc_outgoing', transactions);
  }

  static Future<List<TransactionDtoUsdc>> getUsdcOutgoingTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions_usdc_outgoing') ?? [];
    return transactions.map((t) => TransactionDtoUsdc.fromJson(jsonDecode(t))).toList();
  }

  static Future<String> sendSol({required String receiverAddress, required double amountInSol}) async {
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
      final signature = await rpcClient.signAndSendTransaction(
        transaction,
        [senderKeypair],
      );
      print('Transaction sent! Signature: $signature');

      // Save the outgoing transaction
      final currentPriceSolToUsd = await WalletHandler.getSolToUsdcConversionRate();
      final outgoingTransaction = TransactionDtoSol(amount: -amountInSol, price: currentPriceSolToUsd);
      await saveSolOutgoingTransaction(outgoingTransaction);
      return signature;
    } catch (e) {
      print('Error sending SOL: $e');
      throw Exception('Error sending SOL: $e');
    }
  }

  static Future<String> sendUsdc({required String receiverAddress, required double amountInUsdc}) async {
    final usdcMintAddress = '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU';
    final usdcDecimals = 6; // USDC has 6 decimal places
    final usdcAmount = (amountInUsdc * pow(10, usdcDecimals)).toInt();

    final senderPrivateMnemonics = await WalletService.getMnemonics();
    final senderKeypair = await Ed25519HDKeyPair.fromMnemonic(senderPrivateMnemonics);

    try {
      final usdcMint = Ed25519HDPublicKey.fromBase58(usdcMintAddress);
      final receiverPublicKey = Ed25519HDPublicKey.fromBase58(receiverAddress);

      // Get the sender's USDC token account
      final senderUsdcAccount = await solclient.getAssociatedTokenAccount(
        owner: senderKeypair.publicKey,
        mint: usdcMint,
      );

      // Get or create the receiver's USDC token account
      final receiverUsdcAccount = await solclient.getAssociatedTokenAccount(
        owner: receiverPublicKey,
        mint: usdcMint,
      );

      final instructions = <Instruction>[];

      // If receiver's USDC account doesn't exist, add instruction to create it
      if (receiverUsdcAccount == null) {
        await solclient.createAssociatedTokenAccount(
          mint: usdcMint,
          funder: senderKeypair,
          owner: receiverPublicKey,
        );
      }

      final res = await solclient.transferSplToken(
        mint: usdcMint,
        destination: receiverPublicKey,
        amount: usdcAmount,
        owner: senderKeypair,
      );

      print('USDC Transaction sent! Signature: $res');

      // Save the outgoing transaction
      final currentPriceUsdcToUsd = 1.0; // USDC is pegged to USD, so the rate is always 1:1
      final outgoingTransaction = TransactionDtoUsdc(amount: -amountInUsdc, price: currentPriceUsdcToUsd);
      await saveUsdcOutgoingTransaction(outgoingTransaction);
      return res;
    } catch (e) {
      print('Error sending USDC: $e');
      throw e;
    }
  }
}

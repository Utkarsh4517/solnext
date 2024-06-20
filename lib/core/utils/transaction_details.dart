import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solnext/core/models/transaction.dart';

class TransactionManager {
  static Future<void> saveTransaction(TransactionDTO transaction) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions') ?? [];
    transactions.add(jsonEncode(transaction.toJson()));
    await prefs.setStringList('transactions', transactions);
  }

  static Future<List<TransactionDTO>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactions = prefs.getStringList('transactions') ?? [];
    return transactions.map((t) => TransactionDTO.fromJson(jsonDecode(t))).toList();
  }

  static Future<void> savePreviousBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('previousBalance', balance);
  }

  static Future<double> getPreviousBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('previousBalance') ?? 0.0;
  }
}

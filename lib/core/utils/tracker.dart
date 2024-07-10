import 'package:solnext/core/models/transactionDTO.dart';
import 'package:solnext/core/utils/transaction_manager.dart';
import 'package:solnext/core/utils/wallet_service.dart';
import 'package:solnext/src/home/data/wallet.dart';

class Tracker {
  static Future<
      ({
        String currentValue,
        String priceInSol,
        String priceOfSolInUsd,
        String priceInUsdc,
        String priceOfUsdcInUsd,
        String profitOrLoss,
        String profitOrLossPercentage,
        String profitOrLossSol,
        String profitOrLossUsdc,
        String profitOrLossUsdcPercentage,
        String profitOrLossSolPercentage,
        String publicAddress
      })> fetchBalance() async {
    final pubAdd = await WalletService.getPublicKey();
    final usdcMintAddress = '4zMMC9srt5Ri5X14GAgXhaHii3GnPAEERYPJgZJDncDU';

    /// FOR SOL
    final currentBalanceInSol = await WalletHandler.getBalance(pubAdd);
    final previousBalanceInSol = await TransactionManager.getSOLPreviousBalance();
    // Check for new SOL deposits
    if (currentBalanceInSol > previousBalanceInSol) {
      final newDeposit = currentBalanceInSol - previousBalanceInSol;
      // Fetch the current price of SOL
      final currentPriceSolToUsd = await WalletHandler.getSolToUsdcConversionRate();
      final newTransaction = TransactionDtoSol(amount: newDeposit, price: currentPriceSolToUsd);
      await TransactionManager.saveSolTransaction(newTransaction);
      await TransactionManager.saveSOLPreviousBalance(currentBalanceInSol);
    }

    final conversionRateSolToUsd = await WalletHandler.getSolToUsdcConversionRate();
    final currentBalanceOfSolInUSD = currentBalanceInSol * conversionRateSolToUsd;

    /// FOR USDC
    final currentBalanceInUsdc = await WalletHandler.getTokenBalance(pubAdd, usdcMintAddress);
    final previousBalanceInUsdc = await TransactionManager.getUSDCPreviousBalance();
    // check for new USDC deposits
    if (currentBalanceInUsdc > previousBalanceInUsdc) {
      final newDeposit = currentBalanceInUsdc - previousBalanceInUsdc;
      final currentPriceUsdcToUsd = await WalletHandler.getUsdcToUsdConversionRate();
      final newTransaction = TransactionDtoUsdc(amount: newDeposit, price: currentPriceUsdcToUsd);
      await TransactionManager.saveUsdcTransaction(newTransaction);
      await TransactionManager.saveUSDCPreviousBalance(currentBalanceInUsdc);
    }
    final conversionRateUsdcToUsd = await WalletHandler.getUsdcToUsdConversionRate();
    final currentBalanceOfUsdcInUsd = currentBalanceInUsdc * conversionRateUsdcToUsd;
    double totalInvestment = 0.0; // total investment in SOL + USDC
    double totalInvestmentSol = 0.0;
    double totalInvestementUsdc = 0.0;
    double totalSolBought = 0.0;
    double totalSolSold = 0.0;
    double totalUsdcBought = 0.0;
    double totalUsdcSold = 0.0;

    // Fetch the transaction history for SOL
    final solTransactions = await TransactionManager.getSolTransactions();
    final solOutgoingTransactions = await TransactionManager.getSolOutgoingTransactions();
    // Process each transaction to calculate the total investment, total SOL bought, and total SOL sold
    for (var transaction in solTransactions) {
      if (transaction.amount > 0) {
        // Buy transaction
        totalInvestment += transaction.amount * transaction.price;
        totalInvestmentSol += transaction.amount * transaction.price;
        totalSolBought += transaction.amount;
      }
    }
    for (var transaction in solOutgoingTransactions) {
      // Sell transaction
      totalSolSold += transaction.amount.abs();
      totalInvestment -= transaction.amount.abs() * transaction.price;
      totalInvestmentSol -= transaction.amount.abs() * transaction.price;
    }

    // fetch the transaction history for USDC
    final usdcTransactions = await TransactionManager.getUsdcTransactions();
    final usdcOutgoingTransactions = await TransactionManager.getUsdcOutgoingTransactions();
    // Process each transaction to calculate the total investment, total USDC bought, and total USDC sold
    for (var transaction in usdcTransactions) {
      if (transaction.amount > 0) {
        // Buy transaction
        totalInvestment += transaction.amount * transaction.price;
        totalInvestementUsdc += transaction.amount * transaction.price;
        totalUsdcBought += transaction.amount;
      }
    }
    for (var transaction in usdcOutgoingTransactions) {
      // Sell transaction
      totalUsdcSold += transaction.amount.abs();
      totalInvestment -= transaction.amount.abs() * transaction.price;
      totalInvestementUsdc -= transaction.amount.abs() * transaction.price;
    }

    // Calculate net holdings and the current value
    final netSolHoldings = totalSolBought - totalSolSold;
    final netUsdcHoldings = totalUsdcBought - totalUsdcSold;
    final currentValueSol = netSolHoldings * conversionRateSolToUsd;
    final currentValueUsdc = netUsdcHoldings * conversionRateUsdcToUsd;
    final currentValue = currentValueSol + currentValueUsdc;

    // Calculate profit or loss and the percentage
    final profitOrLoss = currentValue - totalInvestment;
    final profitOrLossSol = currentValueSol - totalInvestmentSol;
    final profitOrLossSolPercentage = (totalInvestmentSol != 0) ? (profitOrLossSol / totalInvestmentSol) * 100 : 0.0;
    final profitOrLossUsdc = currentValueUsdc - totalInvestementUsdc;
    final profitOrLossUsdcPercentage = (totalInvestementUsdc != 0) ? (profitOrLossUsdc / totalInvestementUsdc) * 100 : 0.0;
    final profitOrLossPercentage = (totalInvestment != 0) ? (profitOrLoss / totalInvestment) * 100 : 0.0;

    return (
      currentValue: currentValue.toStringAsFixed(2),
      priceInSol: currentBalanceInSol.toString(),
      priceOfSolInUsd: currentBalanceOfSolInUSD.toStringAsFixed(2),
      priceInUsdc: currentBalanceInUsdc.toString(),
      priceOfUsdcInUsd: currentBalanceOfUsdcInUsd.toStringAsFixed(2),
      profitOrLoss: profitOrLoss.toStringAsFixed(2),
      profitOrLossPercentage: profitOrLossPercentage.toStringAsFixed(2),
      profitOrLossSol: profitOrLossSol.toStringAsFixed(2),
      profitOrLossUsdc: profitOrLossUsdc.toStringAsFixed(2),
      profitOrLossUsdcPercentage: profitOrLossUsdcPercentage.toStringAsFixed(2),
      profitOrLossSolPercentage: profitOrLossSolPercentage.toStringAsFixed(2),
      publicAddress: pubAdd,
    );
  }
}

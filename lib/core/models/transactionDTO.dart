class TransactionDtoSol {
  final double amount; // Amount of SOL
  final double price; // Price per SOL in USD

  TransactionDtoSol({required this.amount, required this.price});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'price': price,
      };

  factory TransactionDtoSol.fromJson(Map<String, dynamic> json) => TransactionDtoSol(
        amount: json['amount'],
        price: json['price'],
      );
}

class TransactionDtoUsdc {
  final double amount; // Amount of USDC
  final double price; // Price per USDC in USD

  TransactionDtoUsdc({required this.amount, required this.price});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'price': price,
      };

  factory TransactionDtoUsdc.fromJson(Map<String, dynamic> json) => TransactionDtoUsdc(
        amount: json['amount'],
        price: json['price'],
      );
}

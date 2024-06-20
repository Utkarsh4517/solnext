class TransactionDTO {
  final double amount; // Amount of SOL
  final double price;  // Price per SOL in USD

  TransactionDTO({required this.amount, required this.price});

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'price': price,
  };

  factory TransactionDTO.fromJson(Map<String, dynamic> json) => TransactionDTO(
    amount: json['amount'],
    price: json['price'],
  );
}

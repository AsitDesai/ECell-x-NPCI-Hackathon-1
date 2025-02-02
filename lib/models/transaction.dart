class Transaction {
  final int? transactionId; // Nullable for auto-increment
  final String senderUpiId;
  final String receiverUpiId;
  final double amount;
  final String date;
  final int rewardPoints;

  Transaction({
    this.transactionId,
    required this.senderUpiId,
    required this.receiverUpiId,
    required this.amount,
    required this.date,
    required this.rewardPoints,
  });

  // Convert a Transaction object into a Map
  Map<String, dynamic> toMap() {
    return {
      'transaction_id': transactionId,
      'sender_upi_id': senderUpiId,
      'receiver_upi_id': receiverUpiId,
      'amount': amount,
      'date': date,
      'reward_points': rewardPoints,
    };
  }

  // Create a Transaction object from a Map
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map['transaction_id'],
      senderUpiId: map['sender_upi_id'],
      receiverUpiId: map['receiver_upi_id'],
      amount: map['amount'],
      date: map['date'],
      rewardPoints: map['reward_points'],
    );
  }
}
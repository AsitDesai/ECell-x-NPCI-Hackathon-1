class Bill {
  final String id;
  final int transactionId;
  final String item;
  final double price;
  final int quantity;
  final String senderUpiId;
  final String receiverUpiId;
  final DateTime date;
  final String userId;
  final int rewardPoints; // Add this field

  Bill({
    required this.id,
    required this.transactionId,
    required this.item,
    required this.price,
    required this.quantity,
    required this.senderUpiId,
    required this.receiverUpiId,
    required this.date,
    required this.userId,
    required this.rewardPoints, // Add this
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'item': item,
      'price': price,
      'quantity': quantity,
      'senderUpiId': senderUpiId,
      'receiverUpiId': receiverUpiId,
      'date': date.toIso8601String(),
      'userId': userId,
      'reward_points': rewardPoints, // Add this
    };
  }

  static Bill fromMap(Map<String, dynamic> map, String id) {
    return Bill(
      id: id,
      transactionId: map['transactionId'],
      item: map['item'],
      price: map['price'],
      quantity: map['quantity'],
      senderUpiId: map['senderUpiId'],
      receiverUpiId: map['receiverUpiId'],
      date: DateTime.parse(map['date']),
      userId: map['userId'],
      rewardPoints: map['reward_points'] ?? 0, // Add this
    );
  }
}
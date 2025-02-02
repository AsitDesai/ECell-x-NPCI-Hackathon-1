class Bill {
  final int? txnId; // Nullable for auto-increment
  final double price;
  final String item;
  final int quantity;

  Bill({
    this.txnId,
    required this.price,
    required this.item,
    required this.quantity,
  });

  // Convert a Bill object into a Map
  Map<String, dynamic> toMap() {
    return {
      'txn_id': txnId,
      'price': price,
      'item': item,
      'quantity': quantity,
    };
  }

  // Create a Bill object from a Map
  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      txnId: map['txn_id'],
      price: map['price'],
      item: map['item'],
      quantity: map['quantity'],
    );
  }
}

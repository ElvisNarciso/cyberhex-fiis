class FiiTransaction {
  final int? id;
  final String ticker;
  final String type; // 'buy' or 'sell'
  final int quantity;
  final double price;
  final DateTime date;

  FiiTransaction({
    this.id,
    required this.ticker,
    required this.type,
    required this.quantity,
    required this.price,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticker': ticker,
      'type': type,
      'quantity': quantity,
      'price': price,
      'date': date.toIso8601String(),
    };
  }

  static FiiTransaction fromMap(Map<String, dynamic> map) {
    return FiiTransaction(
      id: map['id'] as int?,
      ticker: map['ticker'] as String,
      type: map['type'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
      date: DateTime.parse(map['date'] as String),
    );
  }
}

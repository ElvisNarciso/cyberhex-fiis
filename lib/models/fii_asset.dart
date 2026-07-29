class FiiAsset {
  final String ticker;
  final int quantity;
  final double averagePrice;
  final double currentPrice;
  final double pvp;
  final double lastDividend;
  final bool hasNewDocument;

  FiiAsset({
    required this.ticker,
    required this.quantity,
    required this.averagePrice,
    this.currentPrice = 0.0,
    this.pvp = 0.0,
    this.lastDividend = 0.0,
    this.hasNewDocument = false,
  });

  double get totalInvested => quantity * averagePrice;
  double get currentEquity => quantity * currentPrice;
  double get profitability => totalInvested > 0 ? ((currentEquity - totalInvested) / totalInvested) * 100 : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'ticker': ticker,
      'quantity': quantity,
      'averagePrice': averagePrice,
      'currentPrice': currentPrice,
      'pvp': pvp,
      'lastDividend': lastDividend,
      'hasNewDocument': hasNewDocument ? 1 : 0,
    };
  }

  static FiiAsset fromMap(Map<String, dynamic> map) {
    return FiiAsset(
      ticker: map['ticker'] as String,
      quantity: map['quantity'] as int,
      averagePrice: map['averagePrice'] as double,
      currentPrice: map['currentPrice'] as double,
      pvp: map['pvp'] as double,
      lastDividend: map['lastDividend'] as double,
      hasNewDocument: map['hasNewDocument'] == 1,
    );
  }
}

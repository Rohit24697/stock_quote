class StockModel {
  final String symbol;
  final String open;
  final String high;
  final String low;
  final double price;
  final String volume;
  final String latestTradingDay;
  final String previousClose;
  final double change;
  final String changePercent;
  final String sector; // new field

  StockModel({
    required this.symbol,
    required this.open,
    required this.high,
    required this.low,
    required this.price,
    required this.volume,
    required this.latestTradingDay,
    required this.previousClose,
    required this.change,
    required this.changePercent,
    this.sector = 'Unknown', // default value
  });

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'open': open,
      'high': high,
      'low': low,
      'price': price,
      'volume': volume,
      'latestTradingDay': latestTradingDay,
      'previousClose': previousClose,
      'change': change,
      'changePercent': changePercent,
      'sector': sector,
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      symbol: map['symbol'] ?? '',
      open: map['open'] ?? '0',
      high: map['high'] ?? '0',
      low: map['low'] ?? '0',
      price: map['price'] ?? 0.0,
      volume: map['volume'] ?? '0',
      latestTradingDay: map['latestTradingDay'] ?? '',
      previousClose: map['previousClose'] ?? '0',
      change: map['change'] ?? 0.0,
      changePercent: map['changePercent'] ?? '',
      sector: map['sector'] ?? 'Unknown',
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/stock_model.dart';

class StockService {
  static const String _apiKey = 'K2AFZ6MC8DKJ2V5M'; // Replace with your actual API key
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  // Hardcoded mapping of sector to stock symbols
  static final Map<String, List<String>> _sectorSymbols = {
    'Technology': ['AAPL', 'MSFT', 'GOOGL', 'TSLA', 'NVDA'],
    'Healthcare': ['JNJ', 'PFE', 'MRK', 'ABT', 'UNH'],
    'Financial': ['JPM', 'BAC', 'WFC', 'GS', 'MS'],
    'Energy': ['XOM', 'CVX', 'SHEL', 'COP', 'OXY'],
    'Consumer Staples': ['PG', 'KO', 'PEP', 'WMT', 'COST'],
  };

  /// Fetch a single stock quote by symbol
  Future<StockModel?> fetchStockQuote(String symbol, {String sector = 'Unknown'}) async {
    try {
      final String apiUrl =
          '$_baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$_apiKey';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        debugPrint("API response failed with status: ${response.statusCode}");
        return null;
      }

      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('Note')) {
        debugPrint("API Rate Limit Hit: ${data['Note']}");
        return null;
      }

      final quote = data['Global Quote'];
      if (quote == null || quote.isEmpty) {
        debugPrint("No stock data found for symbol: $symbol");
        return null;
      }

      return StockModel(
        symbol: quote['01. symbol'] ?? '',
        open: quote['02. open'] ?? '0',
        high: quote['03. high'] ?? '0',
        low: quote['04. low'] ?? '0',
        price: double.tryParse(quote['05. price'] ?? '0') ?? 0.0,
        volume: quote['06. volume'] ?? '0',
        latestTradingDay: quote['07. latest trading day'] ?? '',
        previousClose: quote['08. previous close'] ?? '0',
        change: double.tryParse(quote['09. change'] ?? '0') ?? 0.0,
        changePercent: quote['10. change percent'] ?? '',
        sector: sector,
      );
    } catch (e) {
      debugPrint("Error fetching stock quote: $e");
      return null;
    }
  }

  /// Fetch list of stock quotes by sector
  Future<List<StockModel>> fetchStocksBySector(String sector) async {
    final List<String> symbols = _sectorSymbols[sector] ?? [];

    if (symbols.isEmpty) {
      debugPrint("No symbols found for sector: $sector");
      return [];
    }

    List<StockModel> stocks = [];

    for (int i = 0; i < symbols.length; i++) {
      final stock = await fetchStockQuote(symbols[i], sector: sector);

      if (stock != null) {
        stocks.add(stock);
      } else {
        debugPrint("Stock data is null for symbol: ${symbols[i]}");
      }

      if (i < symbols.length - 1) {
        await Future.delayed(const Duration(seconds: 15)); // Ensure rate limit buffer
      }
    }

    return stocks;
  }

  /// Get available sector names
  static List<String> getAvailableSectors() {
    return _sectorSymbols.keys.toList();
  }
}

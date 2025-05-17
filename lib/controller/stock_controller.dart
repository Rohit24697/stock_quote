import 'package:get/get.dart';
import '../model/stock_model.dart';
import '../services/database_service.dart';
import '../services/stock_service.dart';

class StockController extends GetxController {
  var stockList = <StockModel>[].obs;           // Stocks loaded for current category
  var filteredStockList = <StockModel>[].obs;   // Filtered by search query
  var isLoading = false.obs;
  var selectedStock = Rxn<StockModel>();        // Selected stock details
  var watchlist = <StockModel>[].obs;           // Full stocks in watchlist
  var isSearching = false.obs;

  final StockService _service = StockService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Default categories with stock symbols
  final Map<String, List<String>> categories = {
    'Technology': ['AAPL', 'MSFT', 'GOOGL', 'TSLA', 'NVDA'],
    'Healthcare': ['JNJ', 'PFE', 'MRK', 'ABT', 'UNH'],
    'Financial': ['JPM', 'BAC', 'WFC', 'GS', 'MS'],
    'Energy': ['XOM', 'CVX', 'SHEL', 'COP', 'OXY'],
    'Consumer Staples': ['PG', 'KO', 'PEP', 'WMT', 'COST'],
  };

  var selectedCategory = 'Technology'.obs; // Default category

  @override
  void onInit() {
    super.onInit();
    loadWatchlist();
    changeCategory(selectedCategory.value); // Load default category stocks
  }

  /// Change category and fetch relevant stocks
  Future<void> changeCategory(String category) async {
    if (category != selectedCategory.value) {
      selectedCategory.value = category;
    }
    await fetchStocks(categories[selectedCategory.value] ?? []);
  }

  /// Fetch multiple stocks by their symbols
  Future<void> fetchStocks(List<String> symbols) async {
    isLoading.value = true;
    stockList.clear();
    filteredStockList.clear();

    for (String symbol in symbols) {
      try {
        final stock = await _service.fetchStockQuote(symbol);
        if (stock != null) {
          stockList.add(stock);
        }
      } catch (e) {
        print('Error fetching stock $symbol: $e');
      }
    }

    filteredStockList.assignAll(stockList); // Initially, filtered = all
    isLoading.value = false;
  }

  /// Fetch details of a single stock by symbol
  Future<void> getStockDetails(String symbol) async {
    isLoading.value = true;
    try {
      final stock = await _service.fetchStockQuote(symbol);
      if (stock != null) {
        selectedStock.value = stock;
      }
    } catch (e) {
      print('Error fetching details for $symbol: $e');
    }
    isLoading.value = false;
  }

  /// Load full stocks from watchlist table (not just symbols)
  Future<void> loadWatchlist() async {
    final List<StockModel> savedStocks = await _dbHelper.getWatchlist();
    watchlist.assignAll(savedStocks);
  }

  /// Add full StockModel to watchlist DB and update local list
  Future<void> addToWatchlist(StockModel stock) async {
    final exists = watchlist.any((s) => s.symbol == stock.symbol);
    if (!exists) {
      final result = await _dbHelper.addToWatchlist(stock);
      if (result != 0) {
        watchlist.add(stock);
        Get.snackbar('Success', '${stock.symbol} added to Watchlist', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to add ${stock.symbol} to Watchlist', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Info', '${stock.symbol} is already in your Watchlist', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Remove stock from watchlist DB and update local list
  Future<void> removeFromWatchlist(String symbol) async {
    final result = await _dbHelper.removeFromWatchlist(symbol);
    if (result > 0) {
      watchlist.removeWhere((s) => s.symbol == symbol);
      Get.snackbar('Success', '$symbol removed from Watchlist', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to remove $symbol from Watchlist', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Check if stock is in watchlist by symbol
  bool isStockInWatchlist(String symbol) {
    return watchlist.any((s) => s.symbol == symbol);
  }

  /// Filter stocks locally by symbol or name
  void filterStocks(String query) {
    if (query.isEmpty) {
      filteredStockList.assignAll(stockList);
    } else {
      final filtered = stockList.where((stock) {
        final lowerQuery = query.toLowerCase();
        return stock.symbol.toLowerCase().contains(lowerQuery) ||
            stock.sector.toLowerCase().contains(lowerQuery);
      }).toList();

      filteredStockList.assignAll(filtered);
    }
  }
}

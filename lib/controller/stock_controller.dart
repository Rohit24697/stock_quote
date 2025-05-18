import 'package:get/get.dart';
import '../model/stock_model.dart';
import '../services/database_service.dart';
import '../services/stock_service.dart';

// This controller is used to manage stocks, categories, and watchlist
class StockController extends GetxController {
  var stockList = <StockModel>[].obs;           // This gives list of stocks for selected category
  var filteredStockList = <StockModel>[].obs;   // This gives list after applying search filter
  var isLoading = false.obs;
  var selectedStock = Rxn<StockModel>();        // This gives currently selected stock
  var watchlist = <StockModel>[].obs;           // This gives list of saved favorite stocks
  var isSearching = false.obs;                  // True when searching stocks

  final StockService _service = StockService(); // Create object/instance of service class to get stock data
  final DatabaseHelper _dbHelper = DatabaseHelper.instance; // Create object/instance of DB helper to store watchlist

  // List of categories and their stock symbols
  final Map<String, List<String>> categories = {
    'Technology': ['AAPL', 'MSFT', 'GOOGL', 'TSLA', 'NVDA'],
    'Healthcare': ['JNJ', 'PFE', 'MRK', 'ABT', 'UNH'],
    'Financial': ['JPM', 'BAC', 'WFC', 'GS', 'MS'],
    'Energy': ['XOM', 'CVX', 'SHEL', 'COP', 'OXY'],
    'Consumer Staples': ['PG', 'KO', 'PEP', 'WMT', 'COST'],
  };

  var selectedCategory = 'Technology'.obs; // This is default selected category

  @override
  void onInit() {
    super.onInit();
    loadWatchlist();                         // This function is used to load saved favorite stocks
    changeCategory(selectedCategory.value);  // This function is used to Load default category stocks
  }

  // Change selected category and load its stocks
  Future<void> changeCategory(String category) async {
    if (category != selectedCategory.value) {
      selectedCategory.value = category; // here is update selected category
    }
    await fetchStocks(categories[selectedCategory.value] ?? []);
  }

  // Get stock data for given list of symbols
  Future<void> fetchStocks(List<String> symbols) async {
    isLoading.value = true;
    stockList.clear();
    filteredStockList.clear();

    for (String symbol in symbols) {
      try {
        final stock = await _service.fetchStockQuote(symbol);
        if (stock != null) {
          stockList.add(stock); // Add to stock list
        }
      } catch (e) {
        print('Error fetching stock $symbol: $e');
      }
    }

    filteredStockList.assignAll(stockList); // This set filtered list same as stock list
    isLoading.value = false;
  }

  // This function to Get full details of a single stock
  Future<void> getStockDetails(String symbol) async {
    isLoading.value = true;
    try {
      final stock = await _service.fetchStockQuote(symbol); // API call
      if (stock != null) {
        selectedStock.value = stock; // Set selected stock
      }
    } catch (e) {
      print('Error fetching details for $symbol: $e'); // Error log
    }
    isLoading.value = false;
  }

  // Function to load saved favorite stocks from local database
  Future<void> loadWatchlist() async {
    final List<StockModel> savedStocks = await _dbHelper.getWatchlist(); // DB call
    watchlist.assignAll(savedStocks); // Update watchlist
  }

  // Function to add a stock to local watchlist database
  Future<void> addToWatchlist(StockModel stock) async {
    final exists = watchlist.any((s) => s.symbol == stock.symbol); // Check if already added
    if (!exists) {
      final result = await _dbHelper.addToWatchlist(stock); // Add to DB
      if (result != 0) {
        watchlist.add(stock); // Add to local list
        Get.snackbar('Success', '${stock.symbol} added to Watchlist', snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to add ${stock.symbol} to Watchlist', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Info', '${stock.symbol} is already in your Watchlist', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Function to remove a stock from local watchlist database
  Future<void> removeFromWatchlist(String symbol) async {
    final result = await _dbHelper.removeFromWatchlist(symbol); // Remove from DB
    if (result > 0) {
      watchlist.removeWhere((s) => s.symbol == symbol); // Remove from local list
      Get.snackbar('Success', '$symbol removed from Watchlist', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to remove $symbol from Watchlist', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Function to check if a stock is in watchlist or not
  bool isStockInWatchlist(String symbol) {
    return watchlist.any((s) => s.symbol == symbol);
  }

  // Function to filter stocks based on search input
  void filterStocks(String query) {
    if (query.isEmpty) {
      filteredStockList.assignAll(stockList); // Show all if search is empty
    } else {
      final filtered = stockList.where((stock) {
        final lowerQuery = query.toLowerCase();
        return stock.symbol.toLowerCase().contains(lowerQuery) ||
            stock.sector.toLowerCase().contains(lowerQuery);
      }).toList();

      filteredStockList.assignAll(filtered); // Show filtered list
    }
  }
}

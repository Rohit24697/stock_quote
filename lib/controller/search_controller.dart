import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/stock_model.dart';
import '../services/stock_service.dart';

class SearchStockController extends GetxController {

  final TextEditingController searchTextController = TextEditingController();

  // It stores the stock result returned by the API
  final searchResult = Rxn<StockModel>();

  // It shows whether the app is loading data
  final isLoading = false.obs;

  // It holds the users search query i.e.symbol and listens for changes
  final RxString searchQuery = ''.obs;

  // Create object/instance of service class which helps us call the API to fetch stock data
  final StockService _service = StockService();

  @override
  void onInit() {
    super.onInit();

    // Debounce helps delay search calls while typing i.e.waits 500ms
    debounce<String>(
      searchQuery,
          (query) {
        if (query.trim().isNotEmpty) {
          searchStock(query.trim()); // It search stock based on user types something
        } else {
          clearSearch(); // Clear result if search box is empty
        }
      },
      time: Duration(milliseconds: 500), // Delay before making API call
    );
  }

  // Called when user types in the search field and update the search query
  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  // Makes API call to fetch stock data based on the symbol
  Future<void> searchStock(String symbol) async {
    isLoading.value = true;
    try {
      final result = await _service.fetchStockQuote(symbol); // It fetches stock
      searchResult.value = result;
    } catch (e) {
      debugPrint('Error searching stock: $e');
      searchResult.value = null; // Clear result on error
      Get.snackbar('Error', 'Failed to fetch stock data');
    } finally {
      isLoading.value = false;
    }
  }

  // It clears the search result
  void clearSearch() {
    searchResult.value = null;
  }

  // Called automatically when controller is disposed
  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}

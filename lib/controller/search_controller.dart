import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/stock_model.dart';
import '../services/stock_service.dart';

class SearchStockController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final searchResult = Rxn<StockModel>();
  final isLoading = false.obs;

  final RxString searchQuery = ''.obs;

  final StockService _service = StockService();

  @override
  void onInit() {
    super.onInit();

    // Listen to text changes with 500ms debounce
    debounce<String>(
      searchQuery,
          (query) {
        if (query.trim().isNotEmpty) {
          searchStock(query.trim());
        } else {
          clearSearch();
        }
      },
      time: Duration(milliseconds: 500),
    );
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  Future<void> searchStock(String symbol) async {
    isLoading.value = true;
    try {
      final result = await _service.fetchStockQuote(symbol);
      searchResult.value = result;
    } catch (e) {
      debugPrint('Error searching stock: $e');
      searchResult.value = null;
      Get.snackbar('Error', 'Failed to fetch stock data');
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchResult.value = null;
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}

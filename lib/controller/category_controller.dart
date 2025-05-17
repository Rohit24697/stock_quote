import 'package:get/get.dart';

import '../model/stock_model.dart'; // Adjust the path if your folder is named 'models' instead
import '../services/stock_service.dart'; // Assuming this is the correct service class

class CategoryController extends GetxController {
  var stockList = <StockModel>[].obs;
  var isLoading = false.obs;
  var selectedSector = 'Technology'.obs;

  final StockService stockService = StockService(); // Instance of the service

  @override
  void onInit() {
    super.onInit();
    fetchStocksBySector(selectedSector.value); // Fetch default sector
  }

  Future<void> fetchStocksBySector(String sector) async {
    try {
      isLoading(true);
      selectedSector.value = sector;

      final stocks = await stockService.fetchStocksBySector(sector); // Non-static call

      if (stocks != null) {
        stockList.assignAll(stocks);
      } else {
        stockList.clear();
      }
    } catch (e) {
      print("Error fetching stocks by sector: $e");
      stockList.clear();
    } finally {
      isLoading(false);
    }
  }
}

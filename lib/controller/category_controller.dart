import 'package:get/get.dart';

import '../model/stock_model.dart'; // Import the StockModel class
import '../services/stock_service.dart';

// Controller to manage stock data based on selected sector
class CategoryController extends GetxController {
  var stockList = <StockModel>[].obs;         // This is Observable list to store fetched stocks
  var isLoading = false.obs;                  // This is Observable flag to show loading state
  var selectedSector = 'Technology'.obs;      // This is Observable to track currently selected sector

  final StockService stockService = StockService(); // create object/instance of service class to fetch stock data

  // Called when controller is first initialized
  @override
  void onInit() {
    super.onInit();
    fetchStocksBySector(selectedSector.value); // It is used to fetch stocks for the default sector i.e. Technology
  }

  // To fetch stocks for a given sector
  Future<void> fetchStocksBySector(String sector) async {
    try {
      isLoading(true);
      selectedSector.value = sector;

      final stocks = await stockService.fetchStocksBySector(sector); // This will fetch data from service

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

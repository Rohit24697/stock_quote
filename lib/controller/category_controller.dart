import 'package:get/get.dart';

import '../model/stock_model.dart'; // Import the StockModel class
import '../services/stock_service.dart';

// Controller to manage stock data based on selected sector
class CategoryController extends GetxController {
  var stockList = <StockModel>[].obs;         // Observable list to store fetched stocks
  var isLoading = false.obs;                  // Observable flag to show loading state
  var selectedSector = 'Technology'.obs;      // Observable to track currently selected sector

  final StockService stockService = StockService(); // Instance of service class to fetch stock data

  // Called when controller is first initialized
  @override
  void onInit() {
    super.onInit();
    fetchStocksBySector(selectedSector.value); // Fetch stocks for the default sector
  }

  // Function to fetch stocks for a given sector
  Future<void> fetchStocksBySector(String sector) async {
    try {
      isLoading(true);                     // Start loading indicator
      selectedSector.value = sector;      // Update selected sector

      final stocks = await stockService.fetchStocksBySector(sector); // Fetch data from service

      if (stocks != null) {
        stockList.assignAll(stocks);      // Update stock list with new data
      } else {
        stockList.clear();                // Clear list if no data returned
      }
    } catch (e) {
      print("Error fetching stocks by sector: $e");
      stockList.clear();
    } finally {
      isLoading(false);
    }
  }
}

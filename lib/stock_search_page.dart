import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/stock_model.dart';
import '../stock_details_page.dart';
import '../controller/search_controller.dart';

class StockSearchPage extends StatelessWidget {

  final SearchStockController searchController = Get.put(SearchStockController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController.searchTextController,

          // It will call function when text is changed
          onChanged: searchController.onSearchChanged,

          decoration: InputDecoration(
            hintText: 'Search for stocks...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),

      body: Obx(() {
        // This show loading spinner if data is loading
        if (searchController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // From this we get the searched stock result
        final stock = searchController.searchResult.value;

        // called if no stock is found or not searched yet
        if (stock == null) {
          return Center(child: Text('Search for a stock to see results.', style: TextStyle(fontSize: 16)));
        }

        // Show the searched stock result in a list tile
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            ListTile(
              // Circle with first letter of stock symbol
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                child: Text(stock.symbol[0]),
              ),

              title: Text(
                stock.symbol,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stock.sector ?? 'No sector info'),
                  SizedBox(height: 4),
                  Text('Price: \$${stock.price.toStringAsFixed(2)}'),
                  Text('Change: ${stock.change.toStringAsFixed(2)} (${stock.changePercent ?? 'N/A'})'),
                ],
              ),
              isThreeLine: true,

              onTap: () => Get.to(() => StockDetailPage(), arguments: stock),
            ),
          ],
        );
      }),
    );
  }
}

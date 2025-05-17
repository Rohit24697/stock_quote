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
          onChanged: searchController.onSearchChanged, // ✅ use this
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
        if (searchController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final stock = searchController.searchResult.value;

        if (stock == null) {
          return Center(child: Text('Search for a stock to see results.', style: TextStyle(fontSize: 16)));
        }

        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            ListTile(
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

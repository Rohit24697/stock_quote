import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_quote/controller/stock_controller.dart';
import 'package:stock_quote/stock_details_page.dart';
import 'package:stock_quote/stock_search_page.dart';
import 'package:stock_quote/watch_list_page.dart';
import 'package:stock_quote/widgets/stock_card.dart';
import 'package:stock_quote/widgets/stock_catagory.dart';

class StockGetxPage extends StatelessWidget {
  StockGetxPage({super.key});

  final StockController stockController = Get.put(StockController());

  final Map<String, List<String>> categories = {
    'Technology': ['AAPL', 'MSFT', 'GOOGL', 'TSLA', 'NVDA'],
    'Healthcare': ['JNJ', 'PFE', 'MRK', 'ABT', 'UNH'],
    'Financial': ['JPM', 'BAC', 'WFC', 'GS', 'MS'],
    'Energy': ['XOM', 'CVX', 'SHEL', 'COP', 'OXY'],
    'Consumer Staples': ['PG', 'KO', 'PEP', 'WMT', 'COST'],
  };

  @override
  Widget build(BuildContext context) {
    // Load default category
    final String defaultCategory = categories.keys.first;
    stockController.changeCategory(defaultCategory);

    return Obx(() => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Stock Quote App",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.white),
            onPressed: () {
              Get.to(() => WatchlistPage());
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Get.to(() => StockSearchPage());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// CATEGORY SELECTION
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    ...categories.keys.map((category) {
                      final isSelected = stockController.selectedCategory.value == category;
                      return StockCategory(
                        label: category,
                        isSelected: isSelected,
                        onTap: () {
                          if (!isSelected) {
                            stockController.changeCategory(category);
                          }
                        },
                      );
                    }).toList(),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            /// STOCK LIST
            Expanded(
              child: Obx(() {
                if (stockController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (stockController.stockList.isEmpty) {
                  return const Center(child: Text("No stock data available"));
                }
                return ListView.builder(
                  itemCount: stockController.stockList.length,
                  itemBuilder: (context, index) {
                    final stock = stockController.stockList[index];
                    final isWatchlisted = stockController.isStockInWatchlist(stock.symbol);

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => StockDetailPage(), arguments: stock);
                      },

                      child: StockCard(
                        stock: stock,
                        isWatchlisted: isWatchlisted,
                        onToggleWatchlist: () {
                          if (isWatchlisted) {
                            stockController.removeFromWatchlist(stock.symbol);
                          } else {
                            stockController.addToWatchlist(stock);
                          }
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    ));
  }
}

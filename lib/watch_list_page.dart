import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/stock_controller.dart';
import 'stock_details_page.dart';
import 'widgets/stock_card.dart';

class WatchlistPage extends StatelessWidget {
  final StockController stockController = Get.find();

  WatchlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Watchlist'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            tooltip: 'Clear Watchlist',
            onPressed: () {
              // Optional: add your own clearWatchlist() logic
              stockController.watchlist.clear(); // UI only, update DB if needed
              Get.snackbar('Cleared', 'Watchlist cleared', snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),
      body: Obx(() {
        final watchlist = stockController.watchlist;

        if (watchlist.isEmpty) {
          return Center(child: Text('No stocks in your watchlist'));
        }

        return ListView.builder(
          itemCount: watchlist.length,
          itemBuilder: (context, index) {
            final stock = watchlist[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => StockDetailPage(), arguments: stock);
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Remove button at top right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => stockController.removeFromWatchlist(stock.symbol),
                        ),
                      ],
                    ),

                    // Stock info display
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: StockCard(
                        stock: stock,
                        isWatchlisted: true,
                        onToggleWatchlist: () =>
                            stockController.removeFromWatchlist(stock.symbol),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

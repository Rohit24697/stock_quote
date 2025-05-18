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

        // It clear all watchlist items using trash icon
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            tooltip: 'Clear Watchlist',

            // When button is pressed, clear the watchlist
            onPressed: () {
              // Remove all items from the watchlist
              stockController.watchlist.clear();

              Get.snackbar('Cleared', 'Watchlist cleared', snackPosition: SnackPosition.BOTTOM);
            },
          ),
        ],
      ),

      body: Obx(() {
        // Get the list of watchlisted stocks
        final watchlist = stockController.watchlist;

        // If no stock is added to watchlist
        if (watchlist.isEmpty) {
          return Center(child: Text('No stocks in your watchlist'));
        }

        // Show list of all stocks in watchlist
        return ListView.builder(
          itemCount: watchlist.length,
          itemBuilder: (context, index) {
            final stock = watchlist[index];

            return GestureDetector(
              // When tapped, go to detail page with stock info
              onTap: () {
                Get.to(() => StockDetailPage(), arguments: stock);
              },

              // It shows each stock inside a card
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Optional: button to remove stock (commented code)
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     IconButton(
                    //       icon: Icon(Icons.remove_circle, color: Colors.red),
                    //       onPressed: () => stockController.removeFromWatchlist(stock.symbol),
                    //     ),
                    //   ],
                    // ),

                    // It shows stock details using custom StockCard widget
                    StockCard(
                      stock: stock,
                      isWatchlisted: true,

                      // When remove icon pressed, remove from watchlist
                      onToggleWatchlist: () =>
                          stockController.removeFromWatchlist(stock.symbol),
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

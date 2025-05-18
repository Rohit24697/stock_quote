// Import necessary packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'controller/stock_controller.dart';
import 'model/stock_model.dart';

// This screen shows the full details of a selected stock
class StockDetailPage extends StatelessWidget {

  final StockController stockController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Get the stock data passed from the previous screen
    final StockModel stock = Get.arguments as StockModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(stock.symbol),

        actions: [
          Obx(() => IconButton(
            icon: Icon(
              // Check if stock is already in watchlist
              stockController.isStockInWatchlist(stock.symbol)
                  ? Icons.remove_circle
                  : Icons.add_to_queue,
              color: Colors.white,
            ),
            onPressed: () {
              // If stock is already in watchlist, remove it
              if (stockController.isStockInWatchlist(stock.symbol)) {
                stockController.removeFromWatchlist(stock.symbol);
              } else {
                // Otherwise, add it to watchlist
                stockController.addToWatchlist(stock);
              }
            },
          )),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stock.sector ?? '',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Divider(),

              _buildInfoRow("Symbol", stock.symbol),
              _buildInfoRow("Open", stock.open),
              _buildInfoRow("High", stock.high),
              _buildInfoRow("Low", stock.low),
              _buildInfoRow("Price", "\$${stock.price.toStringAsFixed(2)}"),
              _buildInfoRow("Volume", stock.volume.toString()),
              _buildInfoRow("Latest Trading Day", stock.latestTradingDay),
              _buildInfoRow("Previous Close", "\$${stock.previousClose}"),
              _buildInfoRow(
                  "Change",
                  "${stock.change.toStringAsFixed(2)} "
                      "(${stock.changePercent})"),
              _buildInfoRow("Sector", stock.sector),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text("$title:", style: TextStyle(fontWeight: FontWeight.w600)),
          ),

          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}

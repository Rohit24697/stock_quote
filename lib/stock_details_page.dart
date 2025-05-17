import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/stock_controller.dart';
import 'model/stock_model.dart';

class StockDetailPage extends StatelessWidget {
  final StockController stockController = Get.find();

  @override
  Widget build(BuildContext context) {
    final StockModel stock = Get.arguments as StockModel;

    // void _launchURL(String symbol) async {
    //   final String url = 'https://www.google.com/finance/quote/$symbol:NASDAQ';
    //   final Uri uri = Uri.parse(url);
    //
    //   if (await canLaunchUrl(uri)) {
    //     await launchUrl(uri, mode: LaunchMode.externalApplication);
    //   } else {
    //     Get.snackbar("Error", "Could not open the stock page",
    //         snackPosition: SnackPosition.BOTTOM);
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(stock.symbol),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              stockController.isStockInWatchlist(stock.symbol)
                  ? Icons.remove_circle
                  : Icons.add_to_queue,
              color: Colors.white,
            ),
            onPressed: () {
              if (stockController.isStockInWatchlist(stock.symbol)) {
                stockController.removeFromWatchlist(stock.symbol);
              } else {
                stockController.addToWatchlist(stock);
              }
            },
          )),
          // IconButton(
          //   icon: Icon(Icons.open_in_browser, color: Colors.white),
          //   onPressed: () => _launchURL(stock.symbol),
          // ),
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
              // SizedBox(height: 20),
              // Center(
              //   child: ElevatedButton.icon(
              //     onPressed: () => _launchURL(stock.symbol),
              //     icon: Icon(Icons.open_in_browser),
              //     label: Text("View on Google Finance"),
              //   ),
              // ),
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
              child:
              Text("$title:", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../model/stock_model.dart';

class StockCard extends StatelessWidget {
  final StockModel stock;
  final bool isWatchlisted;
  final VoidCallback onToggleWatchlist;

  const StockCard({
    super.key,
    required this.stock,
    required this.isWatchlisted,
    required this.onToggleWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('\$${stock.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(
            isWatchlisted ? Icons.remove_circle : Icons.add_circle_outline,
            color: Colors.blue,
          ),
          onPressed: onToggleWatchlist,
        ),
      ),
    );
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/stock_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String watchlistTable = 'watchlist'; // Watchlist table name

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final String path = join(await getDatabasesPath(), 'stock_watchlist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $watchlistTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            symbol TEXT UNIQUE,
            open TEXT,
            high TEXT,
            low TEXT,
            price TEXT,
            volume INTEGER,
            latestTradingDay TEXT,
            previousClose TEXT,
            change TEXT,
            changePercent TEXT,
            sector TEXT
          )
        ''');
      },
    );
  }

  // Insert stock into watchlist table (save full stock details)
  Future<int> addToWatchlist(StockModel stock) async {
    final db = await database;
    try {
      return await db.insert(
        watchlistTable,
        stock.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore, // avoid duplicates by symbol
      );
    } catch (e) {
      print("Error adding to watchlist: $e");
      return 0; // failure
    }
  }

  // Remove a stock from watchlist by symbol
  Future<int> removeFromWatchlist(String symbol) async {
    final db = await database;
    return await db.delete(
      watchlistTable,
      where: 'symbol = ?',
      whereArgs: [symbol],
    );
  }

  // Get all stocks in watchlist (full stock details)
  Future<List<StockModel>> getWatchlist() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(watchlistTable);
    return List.generate(maps.length, (i) => StockModel.fromMap(maps[i]));
  }

  // Check if stock is in watchlist by symbol
  Future<bool> isStockInWatchlist(String symbol) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      watchlistTable,
      where: 'symbol = ?',
      whereArgs: [symbol],
    );
    return result.isNotEmpty;
  }
}

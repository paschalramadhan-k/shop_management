import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

class StockService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // ==========================
  // Get All Products
  // ==========================
  Future<List<Product>> getAllProducts() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: 'name ASC',
    );

    return maps.map((e) => Product.fromMap(e)).toList();
  }

  // ==========================
  // Search Products
  // ==========================
  Future<List<Product>> searchProducts(String keyword) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ? OR category LIKE ?',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: 'name ASC',
    );

    return maps.map((e) => Product.fromMap(e)).toList();
  }

  // ==========================
  // Update Stock Quantity
  // ==========================
  Future<void> updateStock(
      int productId,
      int newQuantity,
      ) async {
    final Database db = await _databaseHelper.database;

    await db.update(
      'products',
      {
        'quantity': newQuantity,
      },
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // ==========================
  // Increase Stock
  // ==========================
  Future<void> increaseStock(
      int productId,
      int amount,
      ) async {
    final Database db = await _databaseHelper.database;

    final product = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (product.isEmpty) return;

    final currentQty = product.first['quantity'] as int;

    await updateStock(
      productId,
      currentQty + amount,
    );
  }

  // ==========================
  // Decrease Stock
  // ==========================
  Future<void> decreaseStock(
      int productId,
      int amount,
      ) async {
    final Database db = await _databaseHelper.database;

    final product = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [productId],
      limit: 1,
    );

    if (product.isEmpty) return;

    final currentQty = product.first['quantity'] as int;

    int newQty = currentQty - amount;

    if (newQty < 0) {
      newQty = 0;
    }

    await updateStock(
      productId,
      newQty,
    );
  }

  // ==========================
  // Low Stock Products
  // ==========================
  Future<List<Product>> getLowStockProducts() async {
    final Database db = await _databaseHelper.database;

    final maps = await db.query(
      'products',
      where: 'quantity <= ?',
      whereArgs: [10],
      orderBy: 'quantity ASC',
    );

    return maps.map((e) => Product.fromMap(e)).toList();
  }

  // ==========================
  // Out Of Stock Products
  // ==========================
  Future<List<Product>> getOutOfStockProducts() async {
    final Database db = await _databaseHelper.database;

    final maps = await db.query(
      'products',
      where: 'quantity = ?',
      whereArgs: [0],
      orderBy: 'name ASC',
    );

    return maps.map((e) => Product.fromMap(e)).toList();
  }

  // ==========================
  // Total Inventory Value
  // (Based on Buying Price)
  // ==========================
  Future<double> getInventoryValue() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT SUM(quantity * buyingPrice) AS total
      FROM products
      ''',
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // ==========================
  // Total Products
  // ==========================
  Future<int> getTotalProducts() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM products',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==========================
  // Low Stock Count
  // ==========================
  Future<int> getLowStockCount() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM products
      WHERE quantity <= 10
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==========================
  // Out Of Stock Count
  // ==========================
  Future<int> getOutOfStockCount() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM products
      WHERE quantity = 0
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==========================
  // Inventory Statistics
  // ==========================
  Future<Map<String, dynamic>> getInventoryStatistics() async {
    return {
      'totalProducts': await getTotalProducts(),
      'lowStock': await getLowStockCount(),
      'outOfStock': await getOutOfStockCount(),
      'inventoryValue': await getInventoryValue(),
    };
  }
}
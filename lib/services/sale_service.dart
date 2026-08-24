import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/product.dart';
import '../models/sale.dart';

class SaleService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // ==============================
  // Record a Sale
  // ==============================
  Future<Sale> recordSale(
      Product product,
      int quantity,
      ) async {
    final Database db = await _databaseHelper.database;

    // Check available stock
    if (quantity > product.quantity) {
      throw Exception("Not enough stock available.");
    }

    // Calculate totals
    final double totalBuying =
        product.buyingPrice * quantity;

    final double totalSelling =
        product.sellingPrice * quantity;

    final double profit =
        totalSelling - totalBuying;

    Sale sale = Sale(
      productId: product.id!,
      productName: product.name,
      category: product.category,
      quantity: quantity,
      buyingPrice: product.buyingPrice,
      sellingPrice: product.sellingPrice,
      totalBuying: totalBuying,
      totalSelling: totalSelling,
      profit: profit,
      saleDate: DateTime.now().toIso8601String(),
    );

    // Save sale
    final int saleId = await db.insert(
      'sales',
      sale.toMap(),
      conflictAlgorithm:
      ConflictAlgorithm.replace,
    );

    // Reduce stock
    final int newQuantity =
        product.quantity - quantity;

    await db.update(
      'products',
      {
        'quantity': newQuantity,
      },
      where: 'id = ?',
      whereArgs: [product.id],
    );

    // Return saved sale with generated ID
    return Sale(
      id: saleId,
      productId: sale.productId,
      productName: sale.productName,
      category: sale.category,
      quantity: sale.quantity,
      buyingPrice: sale.buyingPrice,
      sellingPrice: sale.sellingPrice,
      totalBuying: sale.totalBuying,
      totalSelling: sale.totalSelling,
      profit: sale.profit,
      saleDate: sale.saleDate,
    );
  }

  // ==============================
  // Get All Sales
  // ==============================
  Future<List<Sale>> getAllSales() async {
    final Database db = await _databaseHelper.database;

    final maps = await db.query(
      'sales',
      orderBy: 'saleDate DESC',
    );

    return maps
        .map((e) => Sale.fromMap(e))
        .toList();
  }

  // ==============================
  // Delete Sale
  // ==============================
  Future<int> deleteSale(int id) async {
    final Database db = await _databaseHelper.database;

    return db.delete(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================
  // Today's Sales
  // ==============================
  Future<List<Sale>> getTodaySales() async {
    final Database db = await _databaseHelper.database;

    final String today = DateTime.now()
        .toIso8601String()
        .substring(0, 10);

    final maps = await db.query(
      'sales',
      where: 'saleDate LIKE ?',
      whereArgs: ['$today%'],
      orderBy: 'saleDate DESC',
    );

    return maps
        .map((e) => Sale.fromMap(e))
        .toList();
  }

  // ==============================
  // Total Profit
  // ==============================
  Future<double> getTotalProfit() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT SUM(profit) AS total FROM sales",
    );

    return (result.first['total'] as num?)
        ?.toDouble() ??
        0;
  }

  // ==============================
  // Total Sales
  // ==============================
  Future<double> getTotalSales() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT SUM(totalSelling) AS total FROM sales",
    );

    return (result.first['total'] as num?)
        ?.toDouble() ??
        0;
  }

  // ==============================
  // Sales Count
  // ==============================
  Future<int> getSalesCount() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT COUNT(*) AS total FROM sales",
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
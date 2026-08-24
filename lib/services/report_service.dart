import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class ReportService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // ==========================
  // TODAY
  // ==========================

  Future<double> getTodaySales() async {
    final db = await _databaseHelper.database;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    final result = await db.rawQuery(
      '''
      SELECT SUM(totalSelling) AS total
      FROM sales
      WHERE saleDate LIKE ?
      ''',
      ['$today%'],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTodayProfit() async {
    final db = await _databaseHelper.database;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    final result = await db.rawQuery(
      '''
      SELECT SUM(profit) AS total
      FROM sales
      WHERE saleDate LIKE ?
      ''',
      ['$today%'],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTodayExpenses() async {
    final db = await _databaseHelper.database;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) AS total
      FROM expenses
      WHERE expenseDate LIKE ?
      ''',
      ['$today%'],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // ==========================
  // TOTALS
  // ==========================

  Future<double> getTotalSales() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT SUM(totalSelling) AS total FROM sales",
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalProfit() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT SUM(profit) AS total FROM sales",
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalExpenses() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT SUM(amount) AS total FROM expenses",
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getNetProfit() async {
    final profit = await getTotalProfit();
    final expenses = await getTotalExpenses();

    return profit - expenses;
  }

  // ==========================
  // COUNTS
  // ==========================

  Future<int> getSalesCount() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT COUNT(*) AS total FROM sales",
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalProducts() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT COUNT(*) AS total FROM products",
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getLowStockProducts() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM products
      WHERE quantity <= 10
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getOutOfStockProducts() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM products
      WHERE quantity <= 0
      ''',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==========================
  // MONTHLY
  // ==========================

  Future<double> getMonthlySales() async {
    final db = await _databaseHelper.database;

    final now = DateTime.now();
    final month =
        "${now.year}-${now.month.toString().padLeft(2, '0')}";

    final result = await db.rawQuery(
      '''
      SELECT SUM(totalSelling) AS total
      FROM sales
      WHERE saleDate LIKE ?
      ''',
      ['$month%'],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getMonthlyProfit() async {
    final db = await _databaseHelper.database;

    final now = DateTime.now();
    final month =
        "${now.year}-${now.month.toString().padLeft(2, '0')}";

    final result = await db.rawQuery(
      '''
      SELECT SUM(profit) AS total
      FROM sales
      WHERE saleDate LIKE ?
      ''',
      ['$month%'],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getMonthlyExpenses() async {
    final db = await _databaseHelper.database;

    final now = DateTime.now();
    final month =
        "${now.year}-${now.month.toString().padLeft(2, '0')}";

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) AS total
      FROM expenses
      WHERE expenseDate LIKE ?
      ''',
      ['$month%'],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  // ==========================
  // YEARLY
  // ==========================

  Future<double> getYearlySales() async {
    final db = await _databaseHelper.database;

    final year = DateTime.now().year.toString();

    final result = await db.rawQuery(
      '''
      SELECT SUM(totalSelling) AS total
      FROM sales
      WHERE saleDate LIKE ?
      ''',
      ['$year%'],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getYearlyProfit() async {
    final db = await _databaseHelper.database;

    final year = DateTime.now().year.toString();

    final result = await db.rawQuery(
      '''
      SELECT SUM(profit) AS total
      FROM sales
      WHERE saleDate LIKE ?
      ''',
      ['$year%'],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getYearlyExpenses() async {
    final db = await _databaseHelper.database;

    final year = DateTime.now().year.toString();

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) AS total
      FROM expenses
      WHERE expenseDate LIKE ?
      ''',
      ['$year%'],
    );

    return (result.first["total"] as num?)?.toDouble() ?? 0.0;
  }

  // ==========================
  // BEST SELLING PRODUCTS
  // ==========================

  Future<List<Map<String, dynamic>>> getBestSellingProducts() async {
    final db = await _databaseHelper.database;

    return await db.rawQuery('''
      SELECT
        productName,
        SUM(quantity) AS quantitySold,
        SUM(totalSelling) AS revenue,
        SUM(profit) AS profit
      FROM sales
      GROUP BY productId
      ORDER BY quantitySold DESC
      LIMIT 10
    ''');
  }
}
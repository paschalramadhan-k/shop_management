import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/expense.dart';

class ExpenseService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // ==============================
  // Add Expense
  // ==============================
  Future<int> insertExpense(Expense expense) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==============================
  // Get All Expenses
  // ==============================
  Future<List<Expense>> getAllExpenses() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'expenseDate DESC',
    );

    return List.generate(
      maps.length,
          (index) => Expense.fromMap(maps[index]),
    );
  }

  // ==============================
  // Update Expense
  // ==============================
  Future<int> updateExpense(Expense expense) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // ==============================
  // Delete Expense
  // ==============================
  Future<int> deleteExpense(int id) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================
  // Search Expenses
  // ==============================
  Future<List<Expense>> searchExpenses(String keyword) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: '''
        title LIKE ? OR
        category LIKE ? OR
        description LIKE ?
      ''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: 'expenseDate DESC',
    );

    return List.generate(
      maps.length,
          (index) => Expense.fromMap(maps[index]),
    );
  }

  // ==============================
  // Get Expense By ID
  // ==============================
  Future<Expense?> getExpenseById(int id) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first);
    }

    return null;
  }

  // ==============================
  // Total Expenses
  // ==============================
  Future<double> getTotalExpenses() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM expenses',
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // ==============================
  // Today's Expenses
  // ==============================
  Future<List<Expense>> getTodayExpenses() async {
    final Database db = await _databaseHelper.database;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'expenseDate LIKE ?',
      whereArgs: ['$today%'],
      orderBy: 'expenseDate DESC',
    );

    return maps.map((e) => Expense.fromMap(e)).toList();
  }

  // ==============================
  // Monthly Expenses
  // ==============================
  Future<double> getMonthlyExpenses() async {
    final Database db = await _databaseHelper.database;

    final now = DateTime.now();
    final month =
        '${now.year}-${now.month.toString().padLeft(2, '0')}';

    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) AS total
      FROM expenses
      WHERE expenseDate LIKE ?
      ''',
      ['$month%'],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // ==============================
  // Expense Count
  // ==============================
  Future<int> getExpenseCount() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM expenses',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==============================
  // Refresh Expenses
  // ==============================
  Future<List<Expense>> refreshExpenses() async {
    return await getAllExpenses();
  }
}
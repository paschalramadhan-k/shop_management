import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/app_settings.dart';

class SettingsService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // =====================================
  // Get Shop Settings
  // =====================================
  Future<AppSettings> getSettings() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> result =
    await db.query(
      'settings',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return AppSettings.fromMap(result.first);
    }

    // Should never happen because we insert
    // default settings during database creation.
    return AppSettings(
      id: 1,
      shopName: "My Shop",
      ownerName: "Owner",
      phone: "",
      email: "",
      address: "",
      currency: "TZS",
      taxRate: 0.0,
      lowStockLimit: 10,
      theme: "Light",
      receiptFooter:
      "Thank you for shopping with us!",
    );
  }

  // =====================================
  // Update Settings
  // =====================================
  Future<int> updateSettings(
      AppSettings settings) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }

  // =====================================
  // Reset To Default
  // =====================================
  Future<void> resetSettings() async {
    final Database db = await _databaseHelper.database;

    await db.update(
      'settings',
      {
        "shopName": "My Shop",
        "ownerName": "Owner",
        "phone": "",
        "email": "",
        "address": "",
        "currency": "TZS",
        "taxRate": 0.0,
        "lowStockLimit": 10,
        "theme": "Light",
        "receiptFooter":
        "Thank you for shopping with us!",
      },
      where: "id = ?",
      whereArgs: [1],
    );
  }

  // =====================================
  // Update Currency
  // =====================================
  Future<void> updateCurrency(
      String currency) async {
    final Database db = await _databaseHelper.database;

    await db.update(
      'settings',
      {
        "currency": currency,
      },
      where: "id = ?",
      whereArgs: [1],
    );
  }

  // =====================================
  // Update Theme
  // =====================================
  Future<void> updateTheme(
      String theme) async {
    final Database db = await _databaseHelper.database;

    await db.update(
      'settings',
      {
        "theme": theme,
      },
      where: "id = ?",
      whereArgs: [1],
    );
  }

  // =====================================
  // Update Low Stock Limit
  // =====================================
  Future<void> updateLowStockLimit(
      int limit) async {
    final Database db = await _databaseHelper.database;

    await db.update(
      'settings',
      {
        "lowStockLimit": limit,
      },
      where: "id = ?",
      whereArgs: [1],
    );
  }

  // =====================================
  // Update Tax Rate
  // =====================================
  Future<void> updateTaxRate(
      double taxRate) async {
    final Database db = await _databaseHelper.database;

    await db.update(
      'settings',
      {
        "taxRate": taxRate,
      },
      where: "id = ?",
      whereArgs: [1],
    );
  }
}
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/supplier.dart';

class SupplierService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // ==============================
  // Add Supplier
  // ==============================
  Future<int> insertSupplier(Supplier supplier) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'suppliers',
      supplier.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==============================
  // Get All Suppliers
  // ==============================
  Future<List<Supplier>> getAllSuppliers() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'suppliers',
      orderBy: 'name ASC',
    );

    return List.generate(
      maps.length,
          (index) => Supplier.fromMap(maps[index]),
    );
  }

  // ==============================
  // Update Supplier
  // ==============================
  Future<int> updateSupplier(Supplier supplier) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'suppliers',
      supplier.toMap(),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  // ==============================
  // Delete Supplier
  // ==============================
  Future<int> deleteSupplier(int id) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================
  // Search Suppliers
  // ==============================
  Future<List<Supplier>> searchSuppliers(String keyword) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'suppliers',
      where: '''
        name LIKE ? OR
        phone LIKE ? OR
        email LIKE ? OR
        company LIKE ?
      ''',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: 'name ASC',
    );

    return List.generate(
      maps.length,
          (index) => Supplier.fromMap(maps[index]),
    );
  }

  // ==============================
  // Total Suppliers
  // ==============================
  Future<int> getTotalSuppliers() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM suppliers',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==============================
  // Get Supplier By ID
  // ==============================
  Future<Supplier?> getSupplierById(int id) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Supplier.fromMap(maps.first);
    }

    return null;
  }

  // ==============================
  // Refresh Suppliers
  // ==============================
  Future<List<Supplier>> refreshSuppliers() async {
    return await getAllSuppliers();
  }
}
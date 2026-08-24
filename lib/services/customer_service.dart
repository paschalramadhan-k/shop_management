import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/customer.dart';

class CustomerService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // ==============================
  // Add Customer
  // ==============================
  Future<int> insertCustomer(Customer customer) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==============================
  // Get All Customers
  // ==============================
  Future<List<Customer>> getAllCustomers() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      orderBy: 'name ASC',
    );

    return List.generate(
      maps.length,
          (index) => Customer.fromMap(maps[index]),
    );
  }

  // ==============================
  // Update Customer
  // ==============================
  Future<int> updateCustomer(Customer customer) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // ==============================
  // Delete Customer
  // ==============================
  Future<int> deleteCustomer(int id) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================
  // Search Customers
  // ==============================
  Future<List<Customer>> searchCustomers(String keyword) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
      whereArgs: [
        '%$keyword%',
        '%$keyword%',
        '%$keyword%',
      ],
      orderBy: 'name ASC',
    );

    return List.generate(
      maps.length,
          (index) => Customer.fromMap(maps[index]),
    );
  }

  // ==============================
  // Total Customers
  // ==============================
  Future<int> getTotalCustomers() async {
    final Database db = await _databaseHelper.database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM customers',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ==============================
  // Get Customer By ID
  // ==============================
  Future<Customer?> getCustomerById(int id) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }

    return null;
  }
}
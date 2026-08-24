import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/product.dart';

class ProductService {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insert Product
  Future<int> insertProduct(Product product) async {
    final Database db = await _databaseHelper.database;

    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get All Products
  Future<List<Product>> getAllProducts() async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps =
    await db.query('products', orderBy: 'name ASC');

    return List.generate(maps.length, (index) {
      return Product.fromMap(maps[index]);
    });
  }

  // Update Product
  Future<int> updateProduct(Product product) async {
    final Database db = await _databaseHelper.database;

    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete Product
  Future<int> deleteProduct(int id) async {
    final Database db = await _databaseHelper.database;

    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getTotalProducts() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT COUNT(*) as total FROM products",
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getLowStockCount() async {
    final db = await _databaseHelper.database;

    final result = await db.rawQuery(
      "SELECT COUNT(*) as total FROM products WHERE quantity <= 10",
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Search Products
  Future<List<Product>> searchProducts(String keyword) async {
    final Database db = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (index) {
      return Product.fromMap(maps[index]);
    });
  }
}
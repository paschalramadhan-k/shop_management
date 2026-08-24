import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  // Get database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      "shop_management.db",
    );

    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  //==================================================
  // CREATE DATABASE
  //==================================================

  Future<void> _createDatabase(
      Database db,
      int version,
      ) async {

    // Products
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        buyingPrice REAL NOT NULL,
        sellingPrice REAL NOT NULL,
        quantity INTEGER NOT NULL,
        unit TEXT NOT NULL,
        description TEXT
      )
    ''');

    // Sales
    await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        category TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        buyingPrice REAL NOT NULL,
        sellingPrice REAL NOT NULL,
        totalBuying REAL NOT NULL,
        totalSelling REAL NOT NULL,
        profit REAL NOT NULL,
        saleDate TEXT NOT NULL
      )
    ''');

    // Customers
    await db.execute('''
      CREATE TABLE customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT
      )
    ''');

    // Suppliers
    await db.execute('''
      CREATE TABLE suppliers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        company TEXT,
        address TEXT
      )
    ''');

    // Expenses
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT,
        expenseDate TEXT NOT NULL
      )
    ''');

    // Settings
    await db.execute('''
      CREATE TABLE settings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        shopName TEXT NOT NULL,
        ownerName TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        address TEXT NOT NULL,
        currency TEXT NOT NULL,
        taxRate REAL NOT NULL,
        lowStockLimit INTEGER NOT NULL,
        theme TEXT NOT NULL,
        receiptFooter TEXT NOT NULL
      )
    ''');

    // Default Settings
    await db.insert(
      "settings",
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
    );
  }

  //==================================================
  // DATABASE UPGRADES
  //==================================================

  Future<void> _upgradeDatabase(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {

    // Version 3 - Customers
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS customers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          phone TEXT NOT NULL,
          email TEXT,
          address TEXT
        )
      ''');
    }

    // Version 4 - Suppliers
    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS suppliers(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          phone TEXT NOT NULL,
          email TEXT,
          company TEXT,
          address TEXT
        )
      ''');
    }

    // Version 5 - Expenses
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          category TEXT NOT NULL,
          amount REAL NOT NULL,
          description TEXT,
          expenseDate TEXT NOT NULL
        )
      ''');
    }

    // Version 6 - Settings
    if (oldVersion < 6) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS settings(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          shopName TEXT NOT NULL,
          ownerName TEXT NOT NULL,
          phone TEXT NOT NULL,
          email TEXT NOT NULL,
          address TEXT NOT NULL,
          currency TEXT NOT NULL,
          taxRate REAL NOT NULL,
          lowStockLimit INTEGER NOT NULL,
          theme TEXT NOT NULL,
          receiptFooter TEXT NOT NULL
        )
      ''');

      final count = Sqflite.firstIntValue(
        await db.rawQuery(
          "SELECT COUNT(*) FROM settings",
        ),
      ) ??
          0;

      if (count == 0) {
        await db.insert(
          "settings",
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
        );
      }
    }
  }

  //==================================================
  // CLOSE DATABASE
  //==================================================

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
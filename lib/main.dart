import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'providers/customer_provider.dart';
import 'providers/expense_provider.dart';
import 'providers/product_provider.dart';
import 'providers/sale_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/supplier_provider.dart';

import 'screens/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SaleProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => CustomerProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SupplierProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),

      ],
      child: const ShopManagementApp(),
    ),
  );
}

class ShopManagementApp extends StatelessWidget {
  const ShopManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Shop Management System",

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      home: const LoginScreen(),
    );
  }
}
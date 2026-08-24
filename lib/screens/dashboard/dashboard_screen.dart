import 'package:flutter/material.dart';

import '../customers/customers_screen.dart';
import '../expenses/expenses_screen.dart';
import '../products/products_screen.dart';
import '../reports/reports_screen.dart';
import '../sales/sales_screen.dart';
import '../settings/settings_screen.dart';
import '../stock/stock_screen.dart';
import '../suppliers/suppliers_screen.dart';

class DashboardScreen extends StatelessWidget {
const DashboardScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Dashboard"),
centerTitle: true,
),

body: Padding(
padding: const EdgeInsets.all(16),
child: GridView.count(
crossAxisCount: 2,
crossAxisSpacing: 12,
mainAxisSpacing: 12,
  children: [

    // Products
    _buildCard(
      context,
      title: "Products",
      icon: Icons.inventory,
      color: Colors.orange,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProductsScreen(),
          ),
        );
      },
    ),

    // Sales
    _buildCard(
      context,
      title: "Sales",
      icon: Icons.shopping_cart,
      color: Colors.blue,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SalesScreen(),
          ),
        );
      },
    ),

    // Customers
    _buildCard(
      context,
      title: "Customers",
      icon: Icons.people,
      color: Colors.green,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CustomersScreen(),
          ),
        );
      },
    ),

    // Suppliers
    _buildCard(
      context,
      title: "Suppliers",
      icon: Icons.local_shipping,
      color: Colors.purple,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SuppliersScreen(),
          ),
        );
      },
    ),

    // Stock
    _buildCard(
      context,
      title: "Stock",
      icon: Icons.inventory_2,
      color: Colors.teal,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const StockScreen(),
          ),
        );
      },
    ),

    // Expenses
    _buildCard(
      context,
      title: "Expenses",
      icon: Icons.money_off,
      color: Colors.red,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ExpensesScreen(),
          ),
        );
      },
    ),

    // Reports
    _buildCard(
      context,
      title: "Reports",
      icon: Icons.bar_chart,
      color: Colors.indigo,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ReportsScreen(),
          ),
        );
      },
    ),

    // Settings
    _buildCard(
      context,
      title: "Settings",
      icon: Icons.settings,
      color: Colors.grey,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SettingsScreen(),
          ),
        );
      },
    ),

  ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color.withOpacity(0.15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                icon,
                size: 50,
                color: color,
              ),

              const SizedBox(height: 15),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
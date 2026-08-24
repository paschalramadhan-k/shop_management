import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/stock_service.dart';
import 'update_stock_screen.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
final StockService _stockService = StockService();

final TextEditingController _searchController =
TextEditingController();

List<Product> _products = [];

bool _isLoading = true;

int totalProducts = 0;
int lowStock = 0;
int outOfStock = 0;

double inventoryValue = 0;

@override
void initState() {
super.initState();
_loadInventory();
}

Future<void> _loadInventory() async {
setState(() {
_isLoading = true;
});

_products =
await _stockService.getAllProducts();

final stats =
await _stockService.getInventoryStatistics();

totalProducts = stats["totalProducts"];

lowStock = stats["lowStock"];

outOfStock = stats["outOfStock"];

inventoryValue =
stats["inventoryValue"];

setState(() {
_isLoading = false;
});
}

Future<void> _searchProducts(
String keyword) async {
if (keyword.trim().isEmpty) {
_products =
await _stockService.getAllProducts();
} else {
_products =
await _stockService.searchProducts(
keyword,
);
}

setState(() {});
}

Future<void> _openUpdateStock(
Product product) async {
final result = await Navigator.push(
context,
MaterialPageRoute(
builder: (_) => UpdateStockScreen(
product: product,
),
),
);

if (result == true) {
_loadInventory();
}
}

Future<void> _refresh() async {
await _loadInventory();
}

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
if (_isLoading) {
return const Scaffold(
body: Center(
child: CircularProgressIndicator(),
),
);
}

return Scaffold(
appBar: AppBar(
title: const Text("Stock Management"),
centerTitle: true,
),

body: RefreshIndicator(
onRefresh: _refresh,
child: ListView(
padding: const EdgeInsets.all(16),
children: [

TextField(
controller: _searchController,
onChanged: _searchProducts,
decoration: InputDecoration(
hintText: "Search products...",
prefixIcon:
const Icon(Icons.search),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(12),
),
),
),

const SizedBox(height: 20),

// Inventory Summary
buildInventorySummary(),

const SizedBox(height: 25),

const Text(
"Products",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 12),

..._products.map(
(product) =>
buildProductCard(product),
),

const SizedBox(height: 20),
],
),
),
);
}
//==========================================================
// INVENTORY SUMMARY
//==========================================================

Widget buildInventorySummary() {
return Column(
children: [

Row(
children: [

Expanded(
child: buildSummaryCard(
"Products",
totalProducts.toString(),
Icons.inventory_2,
Colors.blue,
),
),

const SizedBox(width: 10),

Expanded(
child: buildSummaryCard(
"Low Stock",
lowStock.toString(),
Icons.warning_amber,
Colors.orange,
),
),
],
),

const SizedBox(height: 10),

Row(
children: [

Expanded(
child: buildSummaryCard(
"Out of Stock",
outOfStock.toString(),
Icons.error,
Colors.red,
),
),

const SizedBox(width: 10),

Expanded(
child: buildSummaryCard(
"Inventory Value",
inventoryValue.toStringAsFixed(2),
Icons.attach_money,
Colors.green,
),
),
],
),
],
);
}

//==========================================================
// SUMMARY CARD
//==========================================================

Widget buildSummaryCard(
String title,
String value,
IconData icon,
Color color,
) {
return Card(
elevation: 3,
child: Padding(
padding: const EdgeInsets.all(14),
child: Column(
children: [

CircleAvatar(
radius: 22,
backgroundColor: color,
child: Icon(
icon,
color: Colors.white,
),
),

const SizedBox(height: 12),

Text(
value,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 5),

Text(
title,
textAlign: TextAlign.center,
style: const TextStyle(
color: Colors.grey,
),
),
],
),
),
);
}

//==========================================================
// STOCK STATUS BADGE
//==========================================================

Widget buildStatusBadge(Product product) {
Color color;
String text;
IconData icon;

if (product.quantity <= 0) {
color = Colors.red;
text = "Out of Stock";
icon = Icons.cancel;
} else if (product.quantity <= 10) {
color = Colors.orange;
text = "Low Stock";
icon = Icons.warning;
} else {
color = Colors.green;
text = "In Stock";
icon = Icons.check_circle;
}

return Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),
decoration: BoxDecoration(
color: color.withOpacity(0.15),
borderRadius:
BorderRadius.circular(20),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [

Icon(
icon,
color: color,
size: 16,
),

const SizedBox(width: 5),

Text(
text,
style: TextStyle(
color: color,
fontWeight: FontWeight.bold,
fontSize: 12,
),
),
],
),
);
}

//==========================================================
// STOCK COLOR
//==========================================================

Color getStockColor(Product product) {
if (product.quantity <= 0) {
return Colors.red;
}

if (product.quantity <= 10) {
return Colors.orange;
}

return Colors.green;
}
  //==========================================================
  // PRODUCT CARD
  //==========================================================

  Widget buildProductCard(Product product) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        leading: CircleAvatar(
          radius: 28,
          backgroundColor:
          getStockColor(product).withOpacity(0.15),
          child: Icon(
            Icons.inventory,
            color: getStockColor(product),
          ),
        ),

        title: Text(
          product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 6),

            Text(
              "Category: ${product.category}",
            ),

            const SizedBox(height: 4),

            Text(
              "Buying Price: ${product.buyingPrice.toStringAsFixed(2)}",
            ),

            Text(
              "Selling Price: ${product.sellingPrice.toStringAsFixed(2)}",
            ),

            Text(
              "Stock: ${product.quantity} ${product.unit}",
              style: TextStyle(
                color: getStockColor(product),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            buildStatusBadge(product),
          ],
        ),

        trailing: IconButton(
          tooltip: "Update Stock",
          icon: const Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          onPressed: () {
            _openUpdateStock(product);
          },
        ),
      ),
    );
  }
}
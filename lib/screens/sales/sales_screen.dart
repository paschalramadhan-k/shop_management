import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/product_provider.dart';
import 'sell_product_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
final TextEditingController _searchController = TextEditingController();

@override
void initState() {
super.initState();

Future.microtask(() {
context.read<ProductProvider>().loadProducts();
});
}

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

Future<void> _refreshProducts() async {
await context.read<ProductProvider>().loadProducts();
}

void _searchProducts(String keyword) {
context.read<ProductProvider>().searchProducts(keyword);
}

@override
Widget build(BuildContext context) {
final productProvider = context.watch<ProductProvider>();

return Scaffold(
appBar: AppBar(
title: const Text("Sales"),
centerTitle: true,
),

body: Column(
children: [

// Search Box
Padding(
padding: const EdgeInsets.all(12),

child: TextField(
controller: _searchController,
onChanged: _searchProducts,

decoration: InputDecoration(
hintText: "Search product...",
prefixIcon: const Icon(Icons.search),

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
),
),
),
),

Expanded(
child: RefreshIndicator(

onRefresh: _refreshProducts,

child: productProvider.isLoading

? const Center(
child: CircularProgressIndicator(),
)

: productProvider.products.isEmpty

? ListView(
children: const [

SizedBox(height: 180),

Center(
child: Text(
"No products available.",
style: TextStyle(
fontSize: 18,
),
),
),

],
)

: ListView.builder(
itemCount:
productProvider.products.length,

itemBuilder: (context, index) {

final Product product =
productProvider.products[index];

return buildProductCard(product);
},
),
),
),
],
),
);
}
Widget buildProductCard(Product product) {
  return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.category, size: 18),
              const SizedBox(width: 8),
              Text(product.category),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.attach_money,
                size: 18,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                "Selling Price: ${product.sellingPrice.toStringAsFixed(2)}",
              ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              const Icon(
                Icons.inventory_2,
                size: 18,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                "Stock: ${product.quantity} ${product.unit}",
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Text(
                "Status: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                getStockStatus(product.quantity),
                style: TextStyle(
                  color: getStockColor(product.quantity),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: Text(
                product.quantity == 0
                    ? "Out of Stock"
                    : "Sell Product",
              ),
              onPressed: product.quantity == 0
                  ? null
                  : () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SellProductScreen(
                      product: product,
                    ),
                  ),
                );

                if (result == true && mounted) {
                  await context
                      .read<ProductProvider>()
                      .loadProducts();
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

String getStockStatus(int quantity) {
  if (quantity == 0) {
    return "Out of Stock";
  }

  if (quantity <= 10) {
    return "Low Stock";
  }

  return "In Stock";
}

Color getStockColor(int quantity) {
  if (quantity == 0) {
    return Colors.red;
  }

  if (quantity <= 10) {
    return Colors.orange;
  }

  return Colors.green;
}
}
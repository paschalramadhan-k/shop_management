import 'package:flutter/material.dart';

import '../../models/product.dart';
import 'stock_badge.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 26,
                  child: Text(
                    product.name.isNotEmpty
                        ? product.name[0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        product.category,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                StockBadge(
                  quantity: product.quantity,
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: _infoTile(
                    "Buying",
                    product.buyingPrice.toStringAsFixed(2),
                    Icons.shopping_bag,
                    Colors.blue,
                  ),
                ),

                Expanded(
                  child: _infoTile(
                    "Selling",
                    product.sellingPrice.toStringAsFixed(2),
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                Expanded(
                  child: _infoTile(
                    "Quantity",
                    "${product.quantity}",
                    Icons.inventory,
                    Colors.orange,
                  ),
                ),

                Expanded(
                  child: _infoTile(
                    "Unit",
                    product.unit,
                    Icons.straighten,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            if (product.description.isNotEmpty) ...[
              const SizedBox(height: 15),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],

            const Divider(height: 25),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [

                OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Row(
      children: [

        Icon(
          icon,
          color: color,
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),

              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
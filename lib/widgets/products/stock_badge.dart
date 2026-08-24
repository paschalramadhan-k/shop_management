import 'package:flutter/material.dart';

class StockBadge extends StatelessWidget {
  final int quantity;

  const StockBadge({
    super.key,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    if (quantity == 0) {
      color = Colors.red;
      text = "Out of Stock";
    } else if (quantity <= 10) {
      color = Colors.orange;
      text = "Low Stock";
    } else {
      color = Colors.green;
      text = "In Stock";
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
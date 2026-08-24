import 'package:flutter/material.dart';

class EmptyProducts extends StatelessWidget {
  const EmptyProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 90,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "No Products Found",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
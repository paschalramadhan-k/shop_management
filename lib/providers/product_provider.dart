import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];

  List<Product> get products => _products;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await _productService.getAllProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _productService.insertProduct(product);

    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _productService.updateProduct(product);

    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _productService.deleteProduct(id);

    await loadProducts();
  }

  Future<void> searchProducts(String keyword) async {
    if (keyword.isEmpty) {
      await loadProducts();
      return;
    }

    _products =
    await _productService.searchProducts(keyword);

    notifyListeners();
  }

  Future<int> totalProducts() async {
    return await _productService.getTotalProducts();
  }

  Future<int> lowStockProducts() async {
    return await _productService.getLowStockCount();
  }
}
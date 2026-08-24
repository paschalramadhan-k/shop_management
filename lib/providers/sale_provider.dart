import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/sale.dart';
import '../services/sale_service.dart';

class SaleProvider extends ChangeNotifier {
  final SaleService _saleService = SaleService();

  List<Sale> _sales = [];

  List<Sale> get sales => _sales;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadSales() async {
    _isLoading = true;
    notifyListeners();

    _sales = await _saleService.getAllSales();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> recordSale(
      Product product,
      int quantity,
      ) async {
    await _saleService.recordSale(
      product,
      quantity,
    );

    await loadSales();
  }

  Future<double> totalSales() async {
    return await _saleService.getTotalSales();
  }

  Future<double> totalProfit() async {
    return await _saleService.getTotalProfit();
  }

  Future<int> salesCount() async {
    return await _saleService.getSalesCount();
  }
}
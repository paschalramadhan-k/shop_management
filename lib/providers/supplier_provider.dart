import 'package:flutter/material.dart';

import '../models/supplier.dart';
import '../services/supplier_service.dart';

class SupplierProvider extends ChangeNotifier {
  final SupplierService _supplierService = SupplierService();

  List<Supplier> _suppliers = [];

  List<Supplier> get suppliers => _suppliers;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==============================
  // Load All Suppliers
  // ==============================
  Future<void> loadSuppliers() async {
    _isLoading = true;
    notifyListeners();

    _suppliers = await _supplierService.getAllSuppliers();

    _isLoading = false;
    notifyListeners();
  }

  // ==============================
  // Add Supplier
  // ==============================
  Future<void> addSupplier(Supplier supplier) async {
    await _supplierService.insertSupplier(supplier);

    await loadSuppliers();
  }

  // ==============================
  // Update Supplier
  // ==============================
  Future<void> updateSupplier(Supplier supplier) async {
    await _supplierService.updateSupplier(supplier);

    await loadSuppliers();
  }

  // ==============================
  // Delete Supplier
  // ==============================
  Future<void> deleteSupplier(int id) async {
    await _supplierService.deleteSupplier(id);

    await loadSuppliers();
  }

  // ==============================
  // Search Suppliers
  // ==============================
  Future<void> searchSuppliers(String keyword) async {
    if (keyword.trim().isEmpty) {
      await loadSuppliers();
      return;
    }

    _suppliers =
    await _supplierService.searchSuppliers(keyword);

    notifyListeners();
  }

  // ==============================
  // Total Suppliers
  // ==============================
  Future<int> totalSuppliers() async {
    return await _supplierService.getTotalSuppliers();
  }

  // ==============================
  // Get Supplier By ID
  // ==============================
  Future<Supplier?> getSupplierById(int id) async {
    return await _supplierService.getSupplierById(id);
  }

  // ==============================
  // Refresh Suppliers
  // ==============================
  Future<void> refreshSuppliers() async {
    await loadSuppliers();
  }

  // ==============================
  // Clear Local Data
  // ==============================
  void clearSuppliers() {
    _suppliers.clear();
    notifyListeners();
  }
}
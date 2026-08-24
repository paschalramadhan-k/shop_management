import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../services/customer_service.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();

  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==============================
  // Load All Customers
  // ==============================
  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    _customers = await _customerService.getAllCustomers();

    _isLoading = false;
    notifyListeners();
  }

  // ==============================
  // Add Customer
  // ==============================
  Future<void> addCustomer(Customer customer) async {
    await _customerService.insertCustomer(customer);
    await loadCustomers();
  }

  // ==============================
  // Update Customer
  // ==============================
  Future<void> updateCustomer(Customer customer) async {
    await _customerService.updateCustomer(customer);
    await loadCustomers();
  }

  // ==============================
  // Delete Customer
  // ==============================
  Future<void> deleteCustomer(int id) async {
    await _customerService.deleteCustomer(id);
    await loadCustomers();
  }

  // ==============================
  // Search Customers
  // ==============================
  Future<void> searchCustomers(String keyword) async {
    if (keyword.trim().isEmpty) {
      await loadCustomers();
      return;
    }

    _customers = await _customerService.searchCustomers(keyword);
    notifyListeners();
  }

  // ==============================
  // Total Customers
  // ==============================
  Future<int> totalCustomers() async {
    return await _customerService.getTotalCustomers();
  }

  // ==============================
  // Get Customer By ID
  // ==============================
  Future<Customer?> getCustomerById(int id) async {
    return await _customerService.getCustomerById(id);
  }

  // ==============================
  // Refresh Customers
  // ==============================
  Future<void> refreshCustomers() async {
    await loadCustomers();
  }

  // ==============================
  // Clear Local Data
  // ==============================
  void clearCustomers() {
    _customers.clear();
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();

  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // ==============================
  // Load All Expenses
  // ==============================
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await _expenseService.getAllExpenses();

    _isLoading = false;
    notifyListeners();
  }

  // ==============================
  // Add Expense
  // ==============================
  Future<void> addExpense(Expense expense) async {
    await _expenseService.insertExpense(expense);
    await loadExpenses();
  }

  // ==============================
  // Update Expense
  // ==============================
  Future<void> updateExpense(Expense expense) async {
    await _expenseService.updateExpense(expense);
    await loadExpenses();
  }

  // ==============================
  // Delete Expense
  // ==============================
  Future<void> deleteExpense(int id) async {
    await _expenseService.deleteExpense(id);
    await loadExpenses();
  }

  // ==============================
  // Search Expenses
  // ==============================
  Future<void> searchExpenses(String keyword) async {
    if (keyword.trim().isEmpty) {
      await loadExpenses();
      return;
    }

    _expenses = await _expenseService.searchExpenses(keyword);
    notifyListeners();
  }

  // ==============================
  // Get Expense By ID
  // ==============================
  Future<Expense?> getExpenseById(int id) async {
    return await _expenseService.getExpenseById(id);
  }

  // ==============================
  // Refresh Expenses
  // ==============================
  Future<void> refreshExpenses() async {
    await loadExpenses();
  }

  // ==============================
  // Total Expenses
  // ==============================
  Future<double> totalExpenses() async {
    return await _expenseService.getTotalExpenses();
  }

  // ==============================
  // Monthly Expenses
  // ==============================
  Future<double> monthlyExpenses() async {
    return await _expenseService.getMonthlyExpenses();
  }

  // ==============================
  // Today's Expenses
  // ==============================
  Future<List<Expense>> todayExpenses() async {
    return await _expenseService.getTodayExpenses();
  }

  // ==============================
  // Expense Count
  // ==============================
  Future<int> expenseCount() async {
    return await _expenseService.getExpenseCount();
  }

  // ==============================
  // Clear Local Data
  // ==============================
  void clearExpenses() {
    _expenses.clear();
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ExpenseProvider>().loadExpenses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshExpenses() async {
    await context.read<ExpenseProvider>().loadExpenses();
  }

  void _searchExpense(String keyword) {
    context.read<ExpenseProvider>().searchExpenses(keyword);
  }

  Future<void> _openAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddExpenseScreen(),
      ),
    );

    if (result == true && mounted) {
      await context.read<ExpenseProvider>().loadExpenses();
    }
  }

  Future<void> _openEditExpense(
      Expense expense,
      ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          expense: expense,
        ),
      ),
    );

    if (result == true && mounted) {
      await context.read<ExpenseProvider>().loadExpenses();
    }
  }

  Future<void> _deleteExpense(
      Expense expense,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Expense"),
          content: Text(
            "Delete '${expense.title}'?",
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await context
        .read<ExpenseProvider>()
        .deleteExpense(expense.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Expense deleted successfully.",
        ),
      ),
    );
  }

  Widget _buildExpenseCard(
      Expense expense,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange,
          child: const Icon(
            Icons.money_off,
            color: Colors.white,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              "Category: ${expense.category}",
            ),

            Text(
              "Amount: ${expense.amount.toStringAsFixed(2)}",
            ),

            if (expense.description.isNotEmpty)
              Text(
                expense.description,
              ),

            Text(
              "Date: ${expense.expenseDate.substring(0, 10)}",
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              onPressed: () =>
                  _openEditExpense(expense),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () =>
                  _deleteExpense(expense),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<ExpenseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
        centerTitle: true,
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed: _openAddExpense,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _searchExpense,
              decoration: InputDecoration(
                hintText: "Search expenses...",
                prefixIcon:
                const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          FutureBuilder<double>(
            future:
            provider.totalExpenses(),
            builder:
                (context, snapshot) {
              final total =
                  snapshot.data ?? 0;

              return Card(
                margin:
                const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                color: Colors.orange.shade50,
                child: ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.orange,
                  ),
                  title: const Text(
                    "Total Expenses",
                  ),
                  trailing: Text(
                    total.toStringAsFixed(2),
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Expanded(
            child: RefreshIndicator(
              onRefresh:
              _refreshExpenses,
              child: provider.isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : provider
                  .expenses
                  .isEmpty
                  ? ListView(
                children: const [
                  SizedBox(
                      height: 180),
                  Center(
                    child: Text(
                      "No expenses found.",
                      style:
                      TextStyle(
                        fontSize:
                        18,
                      ),
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                itemCount: provider
                    .expenses
                    .length,
                itemBuilder:
                    (context,
                    index) {
                  return _buildExpenseCard(
                    provider
                        .expenses[
                    index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
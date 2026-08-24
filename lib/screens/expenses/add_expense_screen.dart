import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expense.dart';
import '../../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController =
  TextEditingController();

  final TextEditingController _amountController =
  TextEditingController();

  final TextEditingController _descriptionController =
  TextEditingController();

  final List<String> _categories = [
    "Rent",
    "Salary",
    "Transport",
    "Electricity",
    "Water",
    "Internet",
    "Fuel",
    "Maintenance",
    "Tax",
    "Office Supplies",
    "Miscellaneous",
  ];

  String? _selectedCategory;

  DateTime _selectedDate = DateTime.now();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text =
          widget.expense!.amount.toString();
      _descriptionController.text =
          widget.expense!.description;

      _selectedCategory = widget.expense!.category;

      _selectedDate =
          DateTime.parse(widget.expense!.expenseDate);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a category."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final expense = Expense(
      id: widget.expense?.id,
      title: _titleController.text.trim(),
      category: _selectedCategory!,
      amount: double.parse(
        _amountController.text.trim(),
      ),
      description:
      _descriptionController.text.trim(),
      expenseDate: _selectedDate.toIso8601String(),
    );

    try {
      final provider =
      Provider.of<ExpenseProvider>(
        context,
        listen: false,
      );

      if (widget.expense == null) {
        await provider.addExpense(expense);
      } else {
        await provider.updateExpense(expense);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            widget.expense == null
                ? "Expense added successfully."
                : "Expense updated successfully.",
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (label == "Title" ||
              label == "Amount") {
            if (value == null ||
                value.trim().isEmpty) {
              return "$label is required";
            }
          }

          if (label == "Amount") {
            if (double.tryParse(value!) == null) {
              return "Enter a valid amount";
            }

            if (double.parse(value) <= 0) {
              return "Amount must be greater than zero";
            }
          }

          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing =
        widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? "Edit Expense"
              : "Add Expense",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              buildTextField(
                label: "Title",
                controller:
                _titleController,
              ),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration:
                const InputDecoration(
                  labelText:
                  "Category",
                  border:
                  OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (category) =>
                      DropdownMenuItem(
                        value: category,
                        child:
                        Text(category),
                      ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory =
                        value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Select category";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              buildTextField(
                label: "Amount",
                controller:
                _amountController,
                keyboardType:
                const TextInputType
                    .numberWithOptions(
                  decimal: true,
                ),
              ),

              buildTextField(
                label: "Description",
                controller:
                _descriptionController,
                maxLines: 3,
              ),

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading:
                  const Icon(Icons.calendar_today),
                  title: const Text(
                      "Expense Date"),
                  subtitle: Text(
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                  ),
                  trailing:
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text(
                        "Change"),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                ElevatedButton.icon(
                  onPressed:
                  _isSaving
                      ? null
                      : _saveExpense,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors
                          .white,
                    ),
                  )
                      : const Icon(
                      Icons.save),
                  label: Text(
                    _isSaving
                        ? "Saving..."
                        : isEditing
                        ? "Update Expense"
                        : "Save Expense",
                    style:
                    const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
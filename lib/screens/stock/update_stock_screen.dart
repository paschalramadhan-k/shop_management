import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/stock_service.dart';

class UpdateStockScreen extends StatefulWidget {
  final Product product;

  const UpdateStockScreen({
    super.key,
    required this.product,
  });

  @override
  State<UpdateStockScreen> createState() =>
      _UpdateStockScreenState();
}

class _UpdateStockScreenState
    extends State<UpdateStockScreen> {
  final _formKey = GlobalKey<FormState>();

  final StockService _stockService =
  StockService();

  late TextEditingController _quantityController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveStock() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int newQuantity =
    int.parse(_quantityController.text);

    setState(() {
      _isSaving = true;
    });

    try {
      await _stockService.updateStock(
        widget.product.id!,
        newQuantity,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Stock updated successfully.",
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
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

  Widget _infoRow(
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Stock"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              Card(
                elevation: 2,
                child: Padding(
                  padding:
                  const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      Text(
                        product.name,
                        style:
                        const TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 20),

                      _infoRow(
                        "Category",
                        product.category,
                      ),

                      _infoRow(
                        "Buying Price",
                        product.buyingPrice
                            .toStringAsFixed(2),
                      ),

                      _infoRow(
                        "Selling Price",
                        product.sellingPrice
                            .toStringAsFixed(2),
                      ),

                      _infoRow(
                        "Current Stock",
                        "${product.quantity} ${product.unit}",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller:
                _quantityController,
                keyboardType:
                TextInputType.number,
                decoration:
                const InputDecoration(
                  labelText:
                  "New Stock Quantity",
                  border:
                  OutlineInputBorder(),
                  prefixIcon:
                  Icon(Icons.inventory),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return "Enter stock quantity";
                  }

                  final qty =
                  int.tryParse(value);

                  if (qty == null) {
                    return "Enter a valid number";
                  }

                  if (qty < 0) {
                    return "Quantity cannot be negative";
                  }

                  return null;
                },
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
                      : _saveStock,
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
                    Icons.save,
                  ),
                  label: Text(
                    _isSaving
                        ? "Saving..."
                        : "Update Stock",
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
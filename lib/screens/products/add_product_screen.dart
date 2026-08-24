import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({
    super.key,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final ProductService _productService = ProductService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _buyingPriceController =
  TextEditingController();
  final TextEditingController _sellingPriceController =
  TextEditingController();
  final TextEditingController _quantityController =
  TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {

      _nameController.text = widget.product!.name;

      _selectedCategory = widget.product!.category;

      _buyingPriceController.text =
          widget.product!.buyingPrice.toString();

      _sellingPriceController.text =
          widget.product!.sellingPrice.toString();

      _quantityController.text =
          widget.product!.quantity.toString();

      _unitController.text =
          widget.product!.unit;

      _descriptionController.text =
          widget.product!.description;
    }
  }

  final List<String> _categories = [
    "Food",
    "Beverages",
    "Electronics",
    "Cosmetics",
    "Stationery",
    "Hardware",
    "Clothing",
    "Other",
  ];

  String? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _buyingPriceController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id: widget.product?.id,
      name: _nameController.text.trim(),
      category: _selectedCategory!,
      buyingPrice:
      double.tryParse(_buyingPriceController.text.trim()) ?? 0,
      sellingPrice:
      double.tryParse(_sellingPriceController.text.trim()) ?? 0,
      quantity:
      int.tryParse(_quantityController.text.trim()) ?? 0,
      unit: _unitController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (widget.product == null) {
      await _productService.insertProduct(product);
    } else {
      await _productService.updateProduct(product);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          widget.product == null
              ? "Product saved successfully!"
              : "Product updated successfully!",
        ),
      ),
    );

    Navigator.pop(context, true);
  }


  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null
              ? "Add Product"
              : "Edit Product",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField(
                label: "Product Name",
                controller: _nameController,
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "Please select a category";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              buildTextField(
                label: "Buying Price",
                controller: _buyingPriceController,
                keyboardType: TextInputType.number,
              ),

              buildTextField(
                label: "Selling Price",
                controller: _sellingPriceController,
                keyboardType: TextInputType.number,
              ),

              buildTextField(
                label: "Quantity",
                controller: _quantityController,
                keyboardType: TextInputType.number,
              ),

              buildTextField(
                label: "Unit",
                controller: _unitController,
              ),

              buildTextField(
                label: "Description",
                controller: _descriptionController,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveProduct,
                  icon: Icon(
                    widget.product == null
                        ? Icons.save
                        : Icons.update,
                  ),
                  label: Text(
                    widget.product == null
                        ? "Save Product"
                        : "Update Product",
                    style: const TextStyle(
                      fontSize: 18,
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
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../models/sale.dart';

import '../../services/sale_service.dart';
import '../../services/receipt_service.dart';

class SellProductScreen extends StatefulWidget {
  final Product product;

  const SellProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<SellProductScreen> createState() =>
      _SellProductScreenState();
}

class _SellProductScreenState
    extends State<SellProductScreen> {

//=========================================
// Services
//=========================================

final SaleService _saleService =
SaleService();

final ReceiptService _receiptService =
ReceiptService();

//=========================================
// Form
//=========================================

final _formKey =
GlobalKey<FormState>();

final TextEditingController
_quantityController =
TextEditingController();

//=========================================
// Variables
//=========================================

int _quantity = 0;

double _totalSelling = 0;

double _profit = 0;

bool _isSaving = false;

//=========================================
// Calculate totals
//=========================================

void _calculate() {

final qty =
int.tryParse(
_quantityController.text,
) ??
0;

setState(() {

_quantity = qty;

_totalSelling =
widget.product.sellingPrice *
qty;

_profit =
(widget.product.sellingPrice -
widget.product.buyingPrice) *
qty;
});
}

//=========================================
// Complete Sale
//=========================================

Future<void> _completeSale() async {

if (!_formKey.currentState!
.validate()) {
return;
}

if (_quantity <= 0) {

ScaffoldMessenger.of(context)
.showSnackBar(
const SnackBar(
content: Text(
"Enter a valid quantity.",
),
),
);

return;
}

if (_quantity >
widget.product.quantity) {

ScaffoldMessenger.of(context)
.showSnackBar(
const SnackBar(
backgroundColor: Colors.red,
content: Text(
"Not enough stock available.",
),
),
);

return;
}

setState(() {
_isSaving = true;
});

try {

// Record sale
final Sale sale =
await _saleService.recordSale(
widget.product,
_quantity,
);

// Open receipt
await _receiptService
.openReceipt(sale);
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
backgroundColor: Colors.green,
content: Text(
"Sale completed successfully.\nReceipt generated successfully.",
),
),
);

Navigator.pop(
context,
true,
);

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

@override
Widget build(BuildContext context) {

final product = widget.product;

return Scaffold(
appBar: AppBar(
title: const Text(
"Sell Product",
),
centerTitle: true,
),

body: SingleChildScrollView(
padding: const EdgeInsets.all(16),

child: Form(
key: _formKey,

child: Column(
children: [

//=================================
// PRODUCT INFORMATION
//=================================

Card(
elevation: 3,

child: Padding(
padding:
const EdgeInsets.all(16),

child: Column(
children: [

Text(
product.name,
style: const TextStyle(
fontSize: 22,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(
height: 15,
),

Row(
mainAxisAlignment:
MainAxisAlignment
.spaceBetween,
children: [

const Text(
"Category",
),

Text(
product.category,
),
],
),

const Divider(),

Row(
mainAxisAlignment:
MainAxisAlignment
.spaceBetween,
children: [

const Text(
"Available Stock",
),

Text(
"${product.quantity} ${product.unit}",
),
],
),

const Divider(),

Row(
mainAxisAlignment:
MainAxisAlignment
.spaceBetween,
children: [

const Text(
"Buying Price",
),

Text(
product.buyingPrice
.toStringAsFixed(
2),
),
],
),

const Divider(),

Row(
mainAxisAlignment:
MainAxisAlignment
.spaceBetween,
children: [

const Text(
"Selling Price",
),

Text(
product.sellingPrice
.toStringAsFixed(
2),
),
],
),
],
),
),
),

const SizedBox(height: 25),

//=================================
// QUANTITY
//=================================

TextFormField(
controller:
_quantityController,

keyboardType:
TextInputType.number,

onChanged: (_) =>
_calculate(),

decoration:
const InputDecoration(
labelText:
"Quantity to Sell",
border:
OutlineInputBorder(),
prefixIcon:
Icon(Icons.shopping_cart),
),

validator: (value) {

if (value == null ||
value.trim().isEmpty) {
return "Enter quantity";
}

final qty =
int.tryParse(value);

if (qty == null) {
return "Invalid number";
}

if (qty <= 0) {
return "Quantity must be greater than zero";
}

if (qty >
product.quantity) {
return "Stock not enough";
}

return null;
},
),

const SizedBox(height: 25),

//=================================
// TOTALS
//=================================

Card(
color: Colors.blue.shade50,

child: Padding(
padding:
const EdgeInsets.all(16),

child: Column(
children: [

Row(
mainAxisAlignment:
MainAxisAlignment
.spaceBetween,

children: [

const Text(
"Total Amount",
style: TextStyle(
fontWeight:
FontWeight.bold,
),
),

Text(
_totalSelling
.toStringAsFixed(
2),

style:
const TextStyle(
fontWeight:
FontWeight.bold,
),
),
],
),

const SizedBox(
height: 12,
),

Row(
mainAxisAlignment:
MainAxisAlignment
.spaceBetween,

children: [

const Text(
"Profit",
style: TextStyle(
fontWeight:
FontWeight.bold,
),
),

Text(
_profit
.toStringAsFixed(
2),

style:
const TextStyle(
color:
Colors.green,
fontWeight:
FontWeight.bold,
),
),
],
),
],
),
),
),

const SizedBox(height: 30),
  //=================================
// COMPLETE SALE BUTTON
//=================================

  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton.icon(
      onPressed:
      _isSaving ? null : _completeSale,

      icon: _isSaving
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : const Icon(
        Icons.point_of_sale,
      ),

      label: Text(
        _isSaving
            ? "Processing..."
            : "Complete Sale",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),

],
),
),
),
);
}

  //=========================================
  // Dispose
  //=========================================

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
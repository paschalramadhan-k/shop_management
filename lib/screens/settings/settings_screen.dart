import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_settings.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

final _formKey = GlobalKey<FormState>();

final _shopNameController = TextEditingController();
final _ownerController = TextEditingController();
final _phoneController = TextEditingController();
final _emailController = TextEditingController();
final _addressController = TextEditingController();
final _taxController = TextEditingController();
final _lowStockController = TextEditingController();
final _receiptFooterController =
TextEditingController();

String _currency = "TZS";
String _theme = "Light";

bool _loaded = false;

@override
void dispose() {
_shopNameController.dispose();
_ownerController.dispose();
_phoneController.dispose();
_emailController.dispose();
_addressController.dispose();
_taxController.dispose();
_lowStockController.dispose();
_receiptFooterController.dispose();
super.dispose();
}

void _loadData(AppSettings settings) {
if (_loaded) return;

_shopNameController.text = settings.shopName;
_ownerController.text = settings.ownerName;
_phoneController.text = settings.phone;
_emailController.text = settings.email;
_addressController.text = settings.address;
_taxController.text =
settings.taxRate.toString();
_lowStockController.text =
settings.lowStockLimit.toString();
_receiptFooterController.text =
settings.receiptFooter;

_currency = settings.currency;
_theme = settings.theme;

_loaded = true;
}

Future<void> _save() async {
if (!_formKey.currentState!.validate()) {
return;
}

final provider =
context.read<SettingsProvider>();

final current = provider.settings!;

final updated = current.copyWith(
shopName: _shopNameController.text.trim(),
ownerName: _ownerController.text.trim(),
phone: _phoneController.text.trim(),
email: _emailController.text.trim(),
address: _addressController.text.trim(),
currency: _currency,
taxRate:
double.tryParse(_taxController.text) ??
0,
lowStockLimit:
int.tryParse(
_lowStockController.text,
) ??
10,
theme: _theme,
receiptFooter:
_receiptFooterController.text.trim(),
);

await provider.saveSettings(updated);

if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(
const SnackBar(
content: Text(
"Settings saved successfully.",
),
),
);
}

Future<void> _reset() async {
await context
.read<SettingsProvider>()
.resetSettings();

_loaded = false;

if (mounted) {
setState(() {});
}
}

@override
Widget build(BuildContext context) {

final provider =
context.watch<SettingsProvider>();

if (provider.settings == null) {
provider.loadSettings();

return const Scaffold(
body: Center(
child:
CircularProgressIndicator(),
),
);
}

_loadData(provider.settings!);

return Scaffold(
appBar: AppBar(
title: const Text(
"Settings",
),
centerTitle: true,
),

body: Form(
key: _formKey,

child: ListView(
padding:
const EdgeInsets.all(16),

children: [
//==================================================
// SHOP INFORMATION
//==================================================

const Text(
"Shop Information",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

TextFormField(
controller: _shopNameController,
decoration: const InputDecoration(
labelText: "Shop Name",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.store),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Enter shop name";
}
return null;
},
),

const SizedBox(height: 15),

TextFormField(
controller: _ownerController,
decoration: const InputDecoration(
labelText: "Owner Name",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.person),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Enter owner name";
}
return null;
},
),

const SizedBox(height: 30),

//==================================================
// CONTACT INFORMATION
//==================================================

const Text(
"Contact Information",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

TextFormField(
controller: _phoneController,
keyboardType: TextInputType.phone,
decoration: const InputDecoration(
labelText: "Phone Number",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.phone),
),
),

const SizedBox(height: 15),

TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
decoration: const InputDecoration(
labelText: "Email Address",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.email),
),
),

const SizedBox(height: 15),

TextFormField(
controller: _addressController,
maxLines: 3,
decoration: const InputDecoration(
labelText: "Shop Address",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.location_on),
alignLabelWithHint: true,
),
),

const SizedBox(height: 30),
//==================================================
// BUSINESS SETTINGS
//==================================================

const Text(
"Business Settings",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

// Currency
DropdownButtonFormField<String>(
value: _currency,
decoration: const InputDecoration(
labelText: "Currency",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.payments),
),
items: const [

DropdownMenuItem(
value: "TZS",
child: Text("TZS - Tanzanian Shilling"),
),

DropdownMenuItem(
value: "USD",
child: Text("USD - US Dollar"),
),

DropdownMenuItem(
value: "EUR",
child: Text("EUR - Euro"),
),

DropdownMenuItem(
value: "GBP",
child: Text("GBP - British Pound"),
),

],
onChanged: (value) {
if (value != null) {
setState(() {
_currency = value;
});
}
},
),

const SizedBox(height: 15),

// Tax Rate
TextFormField(
controller: _taxController,
keyboardType: const TextInputType.numberWithOptions(
decimal: true,
),
decoration: const InputDecoration(
labelText: "Tax Rate (%)",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.percent),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Enter tax rate";
}

final tax = double.tryParse(value);

if (tax == null) {
return "Invalid number";
}

if (tax < 0) {
return "Tax cannot be negative";
}

return null;
},
),

const SizedBox(height: 15),

// Low Stock Limit
TextFormField(
controller: _lowStockController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: "Low Stock Alert Limit",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.warning_amber),
),
validator: (value) {
if (value == null || value.trim().isEmpty) {
return "Enter low stock limit";
}

final limit = int.tryParse(value);

if (limit == null) {
return "Invalid number";
}

if (limit < 0) {
return "Cannot be negative";
}

return null;
},
),

const SizedBox(height: 15),

// Theme
DropdownButtonFormField<String>(
value: _theme,
decoration: const InputDecoration(
labelText: "Application Theme",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.palette),
),
items: const [

DropdownMenuItem(
value: "Light",
child: Text("Light Theme"),
),

DropdownMenuItem(
value: "Dark",
child: Text("Dark Theme"),
),

],
onChanged: (value) {
if (value != null) {
setState(() {
_theme = value;
});
}
},
),

const SizedBox(height: 30),
//==================================================
// RECEIPT SETTINGS
//==================================================

const Text(
"Receipt Settings",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

TextFormField(
controller: _receiptFooterController,
maxLines: 4,
decoration: const InputDecoration(
labelText: "Receipt Footer",
hintText: "Thank you for shopping with us!",
border: OutlineInputBorder(),
prefixIcon: Icon(Icons.receipt_long),
alignLabelWithHint: true,
),
),

const SizedBox(height: 35),

//==================================================
// ACTION BUTTONS
//==================================================

SizedBox(
width: double.infinity,
height: 50,
child: ElevatedButton.icon(
onPressed: _save,
icon: const Icon(Icons.save),
label: const Text(
"Save Settings",
style: TextStyle(
fontSize: 18,
),
),
),
),

const SizedBox(height: 15),

SizedBox(
width: double.infinity,
height: 50,
child: OutlinedButton.icon(
onPressed: () async {
final confirm =
await showDialog<bool>(
context: context,
builder: (context) {
return AlertDialog(
title: const Text(
"Reset Settings",
),
content: const Text(
"Are you sure you want to restore the default settings?",
),
actions: [

TextButton(
onPressed: () {
Navigator.pop(
context,
false,
);
},
child: const Text(
"Cancel",
),
),

ElevatedButton(
onPressed: () {
Navigator.pop(
context,
true,
);
},
child: const Text(
"Reset",
),
),
],
);
},
) ??
false;

if (!confirm) return;

await _reset();

if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(
const SnackBar(
content: Text(
"Settings restored successfully.",
),
),
);
},
icon: const Icon(Icons.restore),
label: const Text(
"Reset to Default",
style: TextStyle(
fontSize: 18,
),
),
),
),

const SizedBox(height: 20),
],
),
),
);
}
}
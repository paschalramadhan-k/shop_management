import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../models/customer.dart';
import '../models/expense.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../models/supplier.dart';

import 'customer_service.dart';
import 'expense_service.dart';
import 'product_service.dart';
import 'sale_service.dart';
import 'supplier_service.dart';

class ExcelService {

//=========================================
// Services
//=========================================

final ProductService _productService =
ProductService();

final SaleService _saleService =
SaleService();

final CustomerService _customerService =
CustomerService();

final SupplierService _supplierService =
SupplierService();

final ExpenseService _expenseService =
ExpenseService();

//=========================================
// Create Workbook
//=========================================

Excel _createWorkbook() {
return Excel.createExcel();
}

//=========================================
// Save Workbook
//=========================================

Future<File> _saveWorkbook(
Excel excel,
String fileName,
) async {

final Directory directory =
await getApplicationDocumentsDirectory();

final String path =
"${directory.path}/$fileName.xlsx";

final File file = File(path);

final List<int>? bytes =
excel.encode();

if (bytes == null) {
throw Exception(
"Failed to generate Excel file.",
);
}

await file.writeAsBytes(bytes);

return file;
}
//=========================================
// SALES REPORT
//=========================================

Future<File> exportSalesReport() async {

final Excel excel =
_createWorkbook();

final Sheet sheet =
excel['Sales Report'];

//=====================================
// HEADER
//=====================================

sheet.appendRow([
TextCellValue("Sale ID"),
TextCellValue("Product"),
TextCellValue("Category"),
TextCellValue("Quantity"),
TextCellValue("Selling Price"),
TextCellValue("Total Sales"),
TextCellValue("Profit"),
TextCellValue("Date"),
]);

//=====================================
// LOAD SALES
//=====================================

final List<Sale> sales =
await _saleService.getAllSales();

//=====================================
// ADD ROWS
//=====================================

for (final Sale sale in sales) {

sheet.appendRow([

IntCellValue(
sale.id ?? 0,
),

TextCellValue(
sale.productName,
),

TextCellValue(
sale.category,
),

IntCellValue(
sale.quantity,
),

DoubleCellValue(
sale.sellingPrice,
),

DoubleCellValue(
sale.totalSelling,
),

DoubleCellValue(
sale.profit,
),

TextCellValue(
sale.saleDate,
),
]);
}

//=====================================
// AUTO FIT COLUMNS
//=====================================

for (int i = 0; i < 8; i++) {
sheet.setColumnAutoFit(i);
}

//=====================================
// SAVE FILE
//=====================================

return await _saveWorkbook(
excel,
"Sales_Report",
);
}

//=========================================
// PRODUCTS REPORT
//=========================================

Future<File> exportProductsReport() async {

final Excel excel =
_createWorkbook();

final Sheet sheet =
excel['Products Report'];

//=====================================
// HEADER
//=====================================

sheet.appendRow([
TextCellValue("Product"),
TextCellValue("Category"),
TextCellValue("Buying Price"),
TextCellValue("Selling Price"),
TextCellValue("Quantity"),
TextCellValue("Unit"),
TextCellValue("Stock Status"),
]);

//=====================================
// LOAD PRODUCTS
//=====================================

final List<Product> products =
await _productService.getAllProducts();

//=====================================
// ADD PRODUCTS
//=====================================

for (final Product product in products) {

String stockStatus;

if (product.quantity <= 0) {
stockStatus = "Out of Stock";
} else if (product.quantity <= 5) {
stockStatus = "Low Stock";
} else {
stockStatus = "In Stock";
}

sheet.appendRow([

TextCellValue(
product.name,
),

TextCellValue(
product.category,
),

DoubleCellValue(
product.buyingPrice,
),

DoubleCellValue(
product.sellingPrice,
),

IntCellValue(
product.quantity,
),

TextCellValue(
product.unit,
),

TextCellValue(
stockStatus,
),
]);
}

//=====================================
// AUTO FIT COLUMNS
//=====================================

for (int i = 0; i < 7; i++) {
sheet.setColumnAutoFit(i);
}

//=====================================
// SAVE FILE
//=====================================

return await _saveWorkbook(
excel,
"Products_Report",
);
}
//=========================================
// CUSTOMERS REPORT
//=========================================

Future<File> exportCustomersReport() async {

final Excel excel =
_createWorkbook();

final Sheet sheet =
excel['Customers Report'];

//=====================================
// HEADER
//=====================================

sheet.appendRow([
TextCellValue("Customer Name"),
TextCellValue("Phone"),
TextCellValue("Email"),
TextCellValue("Address"),
]);

//=====================================
// LOAD CUSTOMERS
//=====================================

final List<Customer> customers =
await _customerService.getAllCustomers();

//=====================================
// ADD CUSTOMERS
//=====================================

for (final Customer customer in customers) {

sheet.appendRow([

TextCellValue(
customer.name,
),

TextCellValue(
customer.phone,
),

TextCellValue(
customer.email ?? "",
),

TextCellValue(
customer.address ?? "",
),
]);
}

//=====================================
// AUTO FIT COLUMNS
//=====================================

for (int i = 0; i < 4; i++) {
sheet.setColumnAutoFit(i);
}

//=====================================
// SAVE FILE
//=====================================

return await _saveWorkbook(
excel,
"Customers_Report",
);
}

//=========================================
// SUPPLIERS REPORT
//=========================================

Future<File> exportSuppliersReport() async {

final Excel excel =
_createWorkbook();

final Sheet sheet =
excel['Suppliers Report'];

//=====================================
// HEADER
//=====================================

sheet.appendRow([
TextCellValue("Supplier"),
TextCellValue("Company"),
TextCellValue("Phone"),
TextCellValue("Email"),
TextCellValue("Address"),
]);

//=====================================
// LOAD SUPPLIERS
//=====================================

final List<Supplier> suppliers =
await _supplierService.getAllSuppliers();

//=====================================
// ADD SUPPLIERS
//=====================================

for (final Supplier supplier in suppliers) {

sheet.appendRow([

TextCellValue(
supplier.name,
),

TextCellValue(
supplier.company ?? "",
),

TextCellValue(
supplier.phone,
),

TextCellValue(
supplier.email ?? "",
),

TextCellValue(
supplier.address ?? "",
),
]);
}

//=====================================
// AUTO FIT COLUMNS
//=====================================

for (int i = 0; i < 5; i++) {
sheet.setColumnAutoFit(i);
}

//=====================================
// SAVE FILE
//=====================================

return await _saveWorkbook(
excel,
"Suppliers_Report",
);
}

//=========================================
// EXPENSES REPORT
//=========================================

Future<File> exportExpensesReport() async {

final Excel excel =
_createWorkbook();

final Sheet sheet =
excel['Expenses Report'];

//=====================================
// HEADER
//=====================================

sheet.appendRow([
TextCellValue("Title"),
TextCellValue("Category"),
TextCellValue("Amount"),
TextCellValue("Description"),
TextCellValue("Date"),
]);

//=====================================
// LOAD EXPENSES
//=====================================

final List<Expense> expenses =
await _expenseService.getAllExpenses();

//=====================================
// ADD EXPENSES
//=====================================

for (final Expense expense in expenses) {

sheet.appendRow([

TextCellValue(
expense.title,
),

TextCellValue(
expense.category,
),

DoubleCellValue(
expense.amount,
),

TextCellValue(
expense.description ?? "",
),

TextCellValue(
expense.expenseDate,
),
]);
}

//=====================================
// AUTO FIT COLUMNS
//=====================================

for (int i = 0; i < 5; i++) {
sheet.setColumnAutoFit(i);
}

//=====================================
// SAVE FILE
//=====================================

return await _saveWorkbook(
excel,
"Expenses_Report",
);
}
  //=========================================
  // BUSINESS SUMMARY REPORT
  //=========================================

  Future<File> exportBusinessSummaryReport() async {

    final Excel excel =
    _createWorkbook();

    final Sheet sheet =
    excel['Business Summary'];

    //=====================================
    // LOAD DATA
    //=====================================

    final double totalSales =
    await _saleService.getTotalSales();

    final double totalProfit =
    await _saleService.getTotalProfit();

    final List<Expense> expenses =
    await _expenseService.getAllExpenses();

    final List<Product> products =
    await _productService.getAllProducts();

    final List<Customer> customers =
    await _customerService.getAllCustomers();

    final List<Supplier> suppliers =
    await _supplierService.getAllSuppliers();

    //=====================================
    // CALCULATIONS
    //=====================================

    double totalExpenses = 0;

    for (final expense in expenses) {
      totalExpenses += expense.amount;
    }

    final double netProfit =
        totalProfit - totalExpenses;

    final int totalProducts =
        products.length;

    final int lowStockProducts =
        products.where(
              (product) => product.quantity <= 5,
        ).length;

    final int totalCustomers =
        customers.length;

    final int totalSuppliers =
        suppliers.length;

    //=====================================
    // HEADER
    //=====================================

    sheet.appendRow([
      TextCellValue("Business Metric"),
      TextCellValue("Value"),
    ]);

    //=====================================
    // DATA
    //=====================================

    sheet.appendRow([
      TextCellValue("Total Sales"),
      DoubleCellValue(totalSales),
    ]);

    sheet.appendRow([
      TextCellValue("Total Profit"),
      DoubleCellValue(totalProfit),
    ]);

    sheet.appendRow([
      TextCellValue("Total Expenses"),
      DoubleCellValue(totalExpenses),
    ]);

    sheet.appendRow([
      TextCellValue("Net Profit"),
      DoubleCellValue(netProfit),
    ]);

    sheet.appendRow([
      TextCellValue("Total Products"),
      IntCellValue(totalProducts),
    ]);

    sheet.appendRow([
      TextCellValue("Low Stock Products"),
      IntCellValue(lowStockProducts),
    ]);

    sheet.appendRow([
      TextCellValue("Total Customers"),
      IntCellValue(totalCustomers),
    ]);

    sheet.appendRow([
      TextCellValue("Total Suppliers"),
      IntCellValue(totalSuppliers),
    ]);

    //=====================================
    // AUTO FIT
    //=====================================

    sheet.setColumnAutoFit(0);
    sheet.setColumnAutoFit(1);

    //=====================================
    // SAVE FILE
    //=====================================

    return await _saveWorkbook(
      excel,
      "Business_Summary_Report",
    );
  }
}
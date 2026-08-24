import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

import '../../services/excel_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() =>
      _ReportsScreenState();
}

class _ReportsScreenState
    extends State<ReportsScreen> {

//=========================================
// Services
//=========================================

final ExcelService _excelService =
ExcelService();

//=========================================
// Variables
//=========================================

bool _isGenerating = false;

//=========================================
// Export Helper
//=========================================

Future<void> _exportReport(
String reportName,
Future<File> Function() exportFunction,
) async {

setState(() {
_isGenerating = true;
});

try {

final File file =
await exportFunction();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(

  SnackBar(

    backgroundColor: Colors.green,

    content: Text(
      "$reportName generated successfully.",
    ),

    action: SnackBarAction(

      label: "SHARE",

      textColor: Colors.white,

      onPressed: () async {

        await SharePlus.instance.share(
          ShareParams(
            files: [
              XFile(file.path),
            ],
            text: reportName,
          ),
        );

      },
    ),
  ),
);
} catch (e) {

if (!mounted) return;

ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

backgroundColor:
Colors.red,

content: Text(
"Export failed.\n\n$e",
),
),
);

} finally {

if (mounted) {

setState(() {
_isGenerating = false;
});

}
}
}

@override
Widget build(BuildContext context) {

return Scaffold(
appBar: AppBar(
title: const Text("Reports"),
centerTitle: true,
),

body: Stack(
children: [

ListView(
padding: const EdgeInsets.all(16),

children: [

const Text(
"Excel Reports",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

//=========================================
// SALES REPORT
//=========================================

Card(
child: ListTile(
leading: const CircleAvatar(
backgroundColor: Colors.green,
child: Icon(
Icons.bar_chart,
color: Colors.white,
),
),

title: const Text(
"Sales Report",
),

subtitle: const Text(
"Export all sales to Excel",
),

trailing: const Icon(
Icons.download,
),

onTap: () => _exportReport(
"Sales Report",
() => _excelService
.exportSalesReport(),
),
),
),

const SizedBox(height: 12),

//=========================================
// PRODUCTS REPORT
//=========================================

Card(
child: ListTile(
leading: const CircleAvatar(
backgroundColor: Colors.orange,
child: Icon(
Icons.inventory,
color: Colors.white,
),
),

title: const Text(
"Products Report",
),

subtitle: const Text(
"Export inventory to Excel",
),

trailing: const Icon(
Icons.download,
),

onTap: () => _exportReport(
"Products Report",
() => _excelService
.exportProductsReport(),
),
),
),

const SizedBox(height: 12),

//=========================================
// CUSTOMERS REPORT
//=========================================

Card(
child: ListTile(
leading: const CircleAvatar(
backgroundColor: Colors.blue,
child: Icon(
Icons.people,
color: Colors.white,
),
),

title: const Text(
"Customers Report",
),

subtitle: const Text(
"Export customers to Excel",
),

trailing: const Icon(
Icons.download,
),

onTap: () => _exportReport(
"Customers Report",
() => _excelService
.exportCustomersReport(),
),
),
),

const SizedBox(height: 12),
//=========================================
// SUPPLIERS REPORT
//=========================================

Card(
child: ListTile(
leading: const CircleAvatar(
backgroundColor: Colors.purple,
child: Icon(
Icons.local_shipping,
color: Colors.white,
),
),

title: const Text(
"Suppliers Report",
),

subtitle: const Text(
"Export suppliers to Excel",
),

trailing: const Icon(
Icons.download,
),

onTap: () => _exportReport(
"Suppliers Report",
() => _excelService
.exportSuppliersReport(),
),
),
),

const SizedBox(height: 12),

//=========================================
// EXPENSES REPORT
//=========================================

Card(
child: ListTile(
leading: const CircleAvatar(
backgroundColor: Colors.red,
child: Icon(
Icons.account_balance_wallet,
color: Colors.white,
),
),

title: const Text(
"Expenses Report",
),

subtitle: const Text(
"Export expenses to Excel",
),

trailing: const Icon(
Icons.download,
),

onTap: () => _exportReport(
"Expenses Report",
() => _excelService
.exportExpensesReport(),
),
),
),

const SizedBox(height: 12),

//=========================================
// BUSINESS SUMMARY REPORT
//=========================================

Card(
child: ListTile(
leading: const CircleAvatar(
backgroundColor: Colors.teal,
child: Icon(
Icons.analytics,
color: Colors.white,
),
),

title: const Text(
"Business Summary",
),

subtitle: const Text(
"Export business summary to Excel",
),

trailing: const Icon(
Icons.download,
),

onTap: () => _exportReport(
"Business Summary",
() => _excelService
.exportBusinessSummaryReport(),
),
),
),

const SizedBox(height: 20),
],
),

  //=========================================
  // LOADING OVERLAY
  //=========================================

  if (_isGenerating)
    Container(
      color: Colors.black.withOpacity(0.4),

      child: const Center(
        child: Card(
          elevation: 8,

          child: Padding(
            padding: EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                CircularProgressIndicator(),

                SizedBox(height: 20),

                Text(
                  "Generating report...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  "Please wait...",
                ),

              ],
            ),
          ),
        ),
      ),
    ),

],
),
);
}
}
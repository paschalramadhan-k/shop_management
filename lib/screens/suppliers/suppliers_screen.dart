import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/supplier.dart';
import '../../providers/supplier_provider.dart';
import 'add_supplier_screen.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SupplierProvider>().loadSuppliers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshSuppliers() async {
    await context.read<SupplierProvider>().loadSuppliers();
  }

  void _searchSupplier(String keyword) {
    context.read<SupplierProvider>().searchSuppliers(keyword);
  }

  Future<void> _openAddSupplier() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddSupplierScreen(),
      ),
    );

    if (result == true && mounted) {
      await context.read<SupplierProvider>().loadSuppliers();
    }
  }

  Future<void> _openEditSupplier(Supplier supplier) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddSupplierScreen(
          supplier: supplier,
        ),
      ),
    );

    if (result == true && mounted) {
      await context.read<SupplierProvider>().loadSuppliers();
    }
  }

  Future<void> _deleteSupplier(Supplier supplier) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Supplier"),
          content: Text(
            "Delete ${supplier.name}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await context
        .read<SupplierProvider>()
        .deleteSupplier(supplier.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Supplier deleted successfully."),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildSupplierCard(Supplier supplier) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            supplier.name.isNotEmpty
                ? supplier.name[0].toUpperCase()
                : "?",
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          supplier.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            if (supplier.company.isNotEmpty)
              Text("Company: ${supplier.company}"),

            Text("Phone: ${supplier.phone}"),

            if (supplier.email.isNotEmpty)
              Text("Email: ${supplier.email}"),

            if (supplier.address.isNotEmpty)
              Text("Address: ${supplier.address}"),
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
                  _openEditSupplier(supplier),
            ),

            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () =>
                  _deleteSupplier(supplier),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<SupplierProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Suppliers"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSupplier,
        child: const Icon(Icons.person_add_alt_1),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _searchSupplier,
              decoration: InputDecoration(
                hintText: "Search supplier...",
                prefixIcon:
                const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshSuppliers,
              child: provider.isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : provider.suppliers.isEmpty
                  ? ListView(
                children: const [

                  SizedBox(height: 180),

                  Center(
                    child: Text(
                      "No suppliers found.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                ],
              )
                  : ListView.builder(
                itemCount:
                provider.suppliers.length,
                itemBuilder:
                    (context, index) {
                  return _buildSupplierCard(
                    provider.suppliers[index],
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
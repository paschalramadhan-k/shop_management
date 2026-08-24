import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/customer.dart';
import '../../providers/customer_provider.dart';
import 'add_customer_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshCustomers() async {
    await context.read<CustomerProvider>().loadCustomers();
  }

  void _searchCustomer(String keyword) {
    context.read<CustomerProvider>().searchCustomers(keyword);
  }

  Future<void> _openAddCustomer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCustomerScreen(),
      ),
    );

    if (result == true && mounted) {
      await context.read<CustomerProvider>().loadCustomers();
    }
  }

  Future<void> _openEditCustomer(Customer customer) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCustomerScreen(
          customer: customer,
        ),
      ),
    );

    if (result == true && mounted) {
      await context.read<CustomerProvider>().loadCustomers();
    }
  }

  Future<void> _deleteCustomer(Customer customer) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete Customer"),
          content: Text(
            "Delete ${customer.name}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await context
        .read<CustomerProvider>()
        .deleteCustomer(customer.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Customer deleted."),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            customer.name.isNotEmpty
                ? customer.name[0].toUpperCase()
                : "?",
          ),
        ),
        title: Text(
          customer.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text("Phone: ${customer.phone}"),

            if (customer.email.isNotEmpty)
              Text("Email: ${customer.email}"),

            if (customer.address.isNotEmpty)
              Text("Address: ${customer.address}"),
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
                  _openEditCustomer(customer),
            ),

            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () =>
                  _deleteCustomer(customer),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<CustomerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddCustomer,
        child: const Icon(Icons.person_add),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _searchCustomer,
              decoration: InputDecoration(
                hintText: "Search customer...",
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
              onRefresh: _refreshCustomers,
              child: provider.isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : provider.customers.isEmpty
                  ? ListView(
                children: const [

                  SizedBox(height: 180),

                  Center(
                    child: Text(
                      "No customers found.",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),

                ],
              )
                  : ListView.builder(
                itemCount:
                provider.customers.length,
                itemBuilder:
                    (context, index) {
                  return _buildCustomerCard(
                    provider
                        .customers[index],
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
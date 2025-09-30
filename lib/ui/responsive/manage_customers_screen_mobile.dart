import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/customer.dart';

class ManageCustomersScreenMobile extends StatelessWidget {
  final List<Customer> customers;
  final List<Customer> filteredCustomers;
  final bool isLoading;
  final TextEditingController searchController;
  final Function(Customer) onEdit;
  final Function(Customer) onDelete;
  final Function onAdd;

  const ManageCustomersScreenMobile({
    super.key,
    required this.customers,
    required this.filteredCustomers,
    required this.isLoading,
    required this.searchController,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search Customers',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = filteredCustomers[index];
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: Text(
                          '${customer.contactNumber ?? ''} - ${customer.email ?? ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => onEdit(customer),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => onDelete(customer),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

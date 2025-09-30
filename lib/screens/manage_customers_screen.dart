import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../database/db_helper.dart';
import '../models/customer.dart';
import 'add_edit_customer_screen.dart';
import '../ui/responsive/manage_customers_screen_desktop.dart';
import '../ui/responsive/manage_customers_screen_mobile.dart';
import '../ui/responsive/manage_customers_screen_tablet.dart';

class ManageCustomersScreen extends StatefulWidget {
  const ManageCustomersScreen({super.key});

  @override
  State<ManageCustomersScreen> createState() => _ManageCustomersScreenState();
}

class _ManageCustomersScreenState extends State<ManageCustomersScreen> {
  List<Customer> customers = [];
  List<Customer> filteredCustomers = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    searchController.addListener(_filterCustomers);
  }

  Future<void> _loadCustomers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedCustomers = await DatabaseHelper.instance.getAllCustomers();
      setState(() {
        customers = loadedCustomers;
        filteredCustomers = loadedCustomers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading customers: $e')));
      }
    }
  }

  void _filterCustomers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCustomers = customers.where((customer) {
        return customer.name.toLowerCase().contains(query) ||
            (customer.contactNumber?.toLowerCase().contains(query) ?? false) ||
            (customer.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  Future<void> _onEdit(Customer customer) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCustomerScreen(
          customer: customer,
        ),
      ),
    );
    if (result == true) {
      _loadCustomers();
    }
  }

  Future<void> _onDelete(Customer customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text(
          'Are you sure you want to delete "${customer.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DatabaseHelper.instance.deleteCustomer(customer.id!);
        _loadCustomers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Customer deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting customer: $e')),
          );
        }
      }
    }
  }

  void _onAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditCustomerScreen(),
      ),
    );
    if (result == true) {
      _loadCustomers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Customers')),
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => ManageCustomersScreenMobile(
          customers: customers,
          filteredCustomers: filteredCustomers,
          isLoading: isLoading,
          searchController: searchController,
          onEdit: _onEdit,
          onDelete: _onDelete,
          onAdd: _onAdd,
        ),
        tablet: (BuildContext context) => ManageCustomersScreenTablet(
          customers: customers,
          filteredCustomers: filteredCustomers,
          isLoading: isLoading,
          searchController: searchController,
          onEdit: _onEdit,
          onDelete: _onDelete,
          onAdd: _onAdd,
        ),
        desktop: (BuildContext context) => ManageCustomersScreenDesktop(
          customers: customers,
          filteredCustomers: filteredCustomers,
          isLoading: isLoading,
          searchController: searchController,
          onEdit: _onEdit,
          onDelete: _onDelete,
          onAdd: _onAdd,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        tooltip: 'Add Customer',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

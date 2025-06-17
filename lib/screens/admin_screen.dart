import 'package:flutter/material.dart';
import 'manage_inventory_screen.dart';
import 'select_products_screen.dart';
import 'billing_history_screen.dart';
import 'manage_customers_screen.dart';
import '../widgets/custom_card.dart';
import '../services/backup_service.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => _showExportDialog(context),
            tooltip: 'Export Data',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              CustomCard(
                icon: Icons.inventory_2_rounded,
                title: 'Manage Inventory',
                subtitle: 'Add, edit, delete products',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageInventoryScreen(),
                    ),
                  );
                },
              ),
              CustomCard(
                icon: Icons.checklist_rounded,
                title: 'Select Products',
                subtitle: 'Choose products for billing',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelectProductsScreen(),
                    ),
                  );
                },
              ),
              CustomCard(
                icon: Icons.people_rounded,
                title: 'Manage Customers',
                subtitle: 'Add, edit customer details',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManageCustomersScreen(),
                    ),
                  );
                },
              ),
              CustomCard(
                icon: Icons.history_rounded,
                title: 'Billing History',
                subtitle: 'View past transactions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BillingHistoryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Choose what data to export:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BackupService.exportProducts(context);
            },
            child: const Text('Products'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BackupService.exportCustomers(context);
            },
            child: const Text('Customers'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BackupService.exportBillingHistory(context);
            },
            child: const Text('Billing History'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

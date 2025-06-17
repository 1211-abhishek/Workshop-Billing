import 'package:flutter/material.dart';
import 'manage_inventory_screen.dart';
import 'select_products_screen.dart';
import 'billing_history_screen.dart';
import 'manage_customers_screen.dart';
import '../widgets/custom_card.dart';
import '../services/backup_service.dart';
import '../responsive_layout.dart';

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
      body: ResponsiveLayout(
        mobile: _buildMobile(context),
        tablet: _buildTablet(context),
        desktop: _buildDesktop(context),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Container(
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
              crossAxisCount: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: _adminCards(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Container(
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
            padding: const EdgeInsets.all(32.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
              children: _adminCards(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 48.0),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 32,
              mainAxisSpacing: 32,
              childAspectRatio: 1.3,
              children: _adminCards(context),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _adminCards(BuildContext context) {
    return [
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
        icon: Icons.history_rounded,
        title: 'Billing History',
        subtitle: 'View all previous bills',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BillingHistoryScreen(),
            ),
          );
        },
      ),
      CustomCard(
        icon: Icons.people_rounded,
        title: 'Manage Customers',
        subtitle: 'Add, edit, delete customers',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageCustomersScreen(),
            ),
          );
        },
      ),
    ];
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

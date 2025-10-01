import 'package:flutter/material.dart';
import 'package:flutter_billing_system/screens/manage_customers_screen.dart';
import 'package:flutter_billing_system/screens/manage_inventory_screen.dart';
import 'package:flutter_billing_system/services/backup_service.dart';

class AdminScreenTablet extends StatelessWidget {
  const AdminScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: [
        _buildAdminCard(
          context,
          icon: Icons.inventory_2_rounded,
          title: 'Manage Products',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageInventoryScreen(),
            ),
          ),
        ),
        _buildAdminCard(
          context,
          icon: Icons.people_rounded,
          title: 'Manage Customers',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageCustomersScreen(),
            ),
          ),
        ),
        _buildAdminCard(
          context,
          icon: Icons.dark_mode_rounded,
          title: 'Dark Mode',
          trailing: Switch(
            value: false, // Replace with actual theme provider value
            onChanged: (value) {
              // Replace with actual theme provider logic
            },
          ),
        ),
        _buildAdminCard(
          context,
          icon: Icons.file_upload_rounded,
          title: 'Import Data',
          onTap: () => _showImportDialog(context),
        ),
        _buildAdminCard(
          context,
          icon: Icons.file_download_rounded,
          title: 'Export Data',
          onTap: () => _showExportDialog(context),
        ),
      ],
    );
  }

  Widget _buildAdminCard(BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text('Choose what data to import:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BackupService.importProducts(context, '');
            },
            child: const Text('Products'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BackupService.importCustomers(context, '');
            },
            child: const Text('Customers'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
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

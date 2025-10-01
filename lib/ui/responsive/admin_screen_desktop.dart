import 'package:flutter/material.dart';
import 'package:flutter_billing_system/screens/manage_customers_screen.dart';
import 'package:flutter_billing_system/screens/manage_inventory_screen.dart';
import 'package:flutter_billing_system/services/backup_service.dart';

class AdminScreenDesktop extends StatelessWidget {
  const AdminScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.inventory_2_rounded),
          title: const Text('Manage Products'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageInventoryScreen(),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.people_rounded),
          title: const Text('Manage Customers'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ManageCustomersScreen(),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.dark_mode_rounded),
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: false, // Replace with actual theme provider value
            onChanged: (value) {
              // Replace with actual theme provider logic
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.file_upload_rounded),
          title: const Text('Import Data'),
          onTap: () => _showImportDialog(context),
        ),
        ListTile(
          leading: const Icon(Icons.file_download_rounded),
          title: const Text('Export Data'),
          onTap: () => _showExportDialog(context),
        ),
      ],
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

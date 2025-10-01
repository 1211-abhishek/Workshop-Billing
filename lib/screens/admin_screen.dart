import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../ui/responsive/admin_screen_desktop.dart';
import '../ui/responsive/admin_screen_mobile.dart';
import '../ui/responsive/admin_screen_tablet.dart';
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
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withAlpha(12),
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: ScreenTypeLayout.builder(
              mobile: (BuildContext context) => const AdminScreenMobile(),
              tablet: (BuildContext context) => const AdminScreenTablet(),
              desktop: (BuildContext context) => const AdminScreenDesktop(),
            ),
          ),
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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

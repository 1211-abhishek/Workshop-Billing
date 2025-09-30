import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:file_selector/file_selector.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../models/customer.dart';

class BackupService {
  static Future<void> exportProducts(BuildContext context) async {
    try {
      final products = await DatabaseHelper.instance.getAllProducts();
      final jsonData = products.map((product) => product.toMap()).toList();

      if (!context.mounted) return;
      await _exportToFile(
        context,
        'products_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json',
        jsonEncode(jsonData),
        'Products exported successfully',
      );
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to export products: $e');
    }
  }

  static Future<void> exportCustomers(BuildContext context) async {
    try {
      final customers = await DatabaseHelper.instance.getAllCustomers();
      final jsonData = customers.map((customer) => customer.toMap()).toList();
      
      if (!context.mounted) return;
      await _exportToFile(
        context,
        'customers_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json',
        jsonEncode(jsonData),
        'Customers exported successfully',
      );
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to export customers: $e');
    }
  }

  static Future<void> exportBillingHistory(BuildContext context) async {
    try {
      final billingHistory = await DatabaseHelper.instance.getAllBillingHistory();
      final jsonData = billingHistory.map((billing) {
        final map = billing.toMap();
        map['items'] = billing.items.map((item) => item.toMap()).toList();
        return map;
      }).toList();
      
      if (!context.mounted) return;
      await _exportToFile(
        context,
        'billing_history_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json',
        jsonEncode(jsonData),
        'Billing history exported successfully',
      );
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to export billing history: $e');
    }
  }

  static Future<void> exportAllData(BuildContext context) async {
    try {
      final products = await DatabaseHelper.instance.getAllProducts();
      final customers = await DatabaseHelper.instance.getAllCustomers();
      final billingHistory = await DatabaseHelper.instance.getAllBillingHistory();
      
      final allData = {
        'products': products.map((product) => product.toMap()).toList(),
        'customers': customers.map((customer) => customer.toMap()).toList(),
        'billingHistory': billingHistory.map((billing) {
          final map = billing.toMap();
          map['items'] = billing.items.map((item) => item.toMap()).toList();
          return map;
        }).toList(),
        'exportDate': DateTime.now().toIso8601String(),
        'version': '1.0',
      };
      
      if (!context.mounted) return;
      await _exportToFile(
        context,
        'complete_backup_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.json',
        jsonEncode(allData),
        'Complete backup exported successfully',
      );
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to export complete backup: $e');
    }
  }

  static Future<void> _exportToFile(
    BuildContext context,
    String fileName,
    String content,
    String successMessage,
  ) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
    
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Billing System Backup',
    );
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    }
  }

  static void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Import functionality for future use
  static Future<void> importProducts(BuildContext context, String jsonContent) async {
    try {
      final List<dynamic> jsonData = jsonDecode(jsonContent);
      final products = jsonData.map((data) => Product.fromMap(data)).toList();
      
      for (final product in products) {
        await DatabaseHelper.instance.insertProduct(product);
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${products.length} products imported successfully')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to import products: $e');
    }
  }

  static Future<void> importCustomers(BuildContext context, String jsonContent) async {
    try {
      final List<dynamic> jsonData = jsonDecode(jsonContent);
      final customers = jsonData.map((data) => Customer.fromMap(data)).toList();
      
      for (final customer in customers) {
        await DatabaseHelper.instance.insertCustomer(customer);
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${customers.length} customers imported successfully')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to import customers: $e');
    }
  }

  static Future<void> importProductsFromFile(BuildContext context) async {
    try {
      final typeGroup = XTypeGroup(label: 'json', extensions: ['json']);
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;

      final content = await file.readAsString();
      if (!context.mounted) return;
      await importProducts(context, content);
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to import products: $e');
    }
  }

  static Future<void> importCustomersFromFile(BuildContext context) async {
    try {
      final typeGroup = XTypeGroup(label: 'json', extensions: ['json']);
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file == null) return;

      final content = await file.readAsString();
      if (!context.mounted) return;
      await importCustomers(context, content);
    } catch (e) {
      if (!context.mounted) return;
      _showError(context, 'Failed to import customers: $e');
    }
  }
}

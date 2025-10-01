import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_history.dart';
import 'package:flutter_billing_system/database/db_helper.dart';

class BillingHistoryProvider with ChangeNotifier {
  List<BillingHistory> _history = [];

  List<BillingHistory> get history => _history;

  Future<void> fetchHistory() async {
    final dbHelper = DatabaseHelper.instance;
    final data = await dbHelper.getAllBillingHistory();
    _history = data.map((item) => BillingHistory.fromMap(item.toMap())).toList();
    notifyListeners();
  }
}

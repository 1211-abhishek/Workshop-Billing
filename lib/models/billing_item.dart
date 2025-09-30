import 'package:flutter_billing_system/models/billing_history.dart';

class BillingItem {
  final String productName;
  final int quantity;
  final double unitPrice;
  final String? unit;

  BillingItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    this.unit,
  });

  double get totalPrice => quantity * unitPrice;

  BillingHistoryItem toBillingHistoryItem() {
    return BillingHistoryItem(
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      unit: unit,
    );
  }
}

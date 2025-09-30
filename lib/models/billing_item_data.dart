import 'package:flutter_billing_system/models/billing_history.dart';
import 'package:flutter_billing_system/models/product.dart';

class BillingItemData {
  final Product product;
  final int quantity;
  final double unitPrice;

  BillingItemData({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  BillingItemData copyWith({
    Product? product,
    int? quantity,
    double? unitPrice,
  }) {
    return BillingItemData(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  BillingHistoryItem toBillingHistoryItem() {
    return BillingHistoryItem(
      productName: product.name,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      unit: product.unit,
    );
  }
}

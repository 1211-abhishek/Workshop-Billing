import 'product.dart';

class BillingHistory {
  final int? id;
  final String invoiceNumber;
  final DateTime date;
  final double totalAmount;
  final double taxAmount;
  final double discountAmount;
  final String? pdfPath;
  final String? customerName;
  final String? customerContact;
  final String? customerAddress;
  final String? remarks;
  final List<BillingItem> items;

  BillingHistory({
    this.id,
    required this.invoiceNumber,
    required this.date,
    required this.totalAmount,
    this.taxAmount = 0.0,
    this.discountAmount = 0.0,
    this.pdfPath,
    this.customerName,
    this.customerContact,
    this.customerAddress,
    this.remarks,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'date': date.toIso8601String(),
      'totalAmount': totalAmount,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'pdfPath': pdfPath,
      'customerName': customerName,
      'customerContact': customerContact,
      'customerAddress': customerAddress,
      'remarks': remarks,
    };
  }

  factory BillingHistory.fromMap(Map<String, dynamic> map) {
    return BillingHistory(
      id: map['id'],
      invoiceNumber: map['invoiceNumber'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      taxAmount: (map['taxAmount'] ?? 0.0).toDouble(),
      discountAmount: (map['discountAmount'] ?? 0.0).toDouble(),
      pdfPath: map['pdfPath'],
      customerName: map['customerName'],
      customerContact: map['customerContact'],
      customerAddress: map['customerAddress'],
      remarks: map['remarks'],
    );
  }
}

class BillingItem {
  final int? id;
  final int billingHistoryId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? unit;

  BillingItem({
    this.id,
    required this.billingHistoryId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.unit = 'pcs',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'billingHistoryId': billingHistoryId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'unit': unit,
    };
  }

  factory BillingItem.fromMap(Map<String, dynamic> map) {
    return BillingItem(
      id: map['id'],
      billingHistoryId: map['billingHistoryId'] ?? 0,
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'pcs',
    );
  }
}

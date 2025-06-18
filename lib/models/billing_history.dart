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
  final String? engineType;
  final String? pump;
  final String? serialNumber;
  final String? governor;
  final String? feedPump;
  final String? noozelHolder;
  final String? vehicleNumber;
  final String? mechanicName;
  final DateTime? arrivedDate;
  final DateTime? deliveredDate;
  final DateTime? billingDate;
  final double? pumpLabourCharge;
  final double? nozzleLabourCharge;
  final double? otherCharges;

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
    this.engineType,
    this.pump,
    this.serialNumber,
    this.governor,
    this.feedPump,
    this.noozelHolder,
    this.vehicleNumber,
    this.mechanicName,
    this.arrivedDate,
    this.deliveredDate,
    this.billingDate,
    this.pumpLabourCharge,
    this.nozzleLabourCharge,
    this.otherCharges,
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
      'engineType': engineType,
      'pump': pump,
      'serialNumber': serialNumber,
      'governor': governor,
      'feedPump': feedPump,
      'noozelHolder': noozelHolder,
      'vehicleNumber': vehicleNumber,
      'mechanicName': mechanicName,
      'arrivedDate': arrivedDate?.toIso8601String(),
      'deliveredDate': deliveredDate?.toIso8601String(),
      'billingDate': billingDate?.toIso8601String(),
      'pumpLabourCharge': pumpLabourCharge,
      'nozzleLabourCharge': nozzleLabourCharge,
      'otherCharges': otherCharges,
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
      engineType: map['engineType'],
      pump: map['pump'],
      serialNumber: map['serialNumber'],
      governor: map['governor'],
      feedPump: map['feedPump'],
      noozelHolder: map['noozelHolder'],
      vehicleNumber: map['vehicleNumber'],
      mechanicName: map['mechanicName'],
      arrivedDate: map['arrivedDate'] != null ? DateTime.tryParse(map['arrivedDate']) : null,
      deliveredDate: map['deliveredDate'] != null ? DateTime.tryParse(map['deliveredDate']) : null,
      billingDate: map['billingDate'] != null ? DateTime.tryParse(map['billingDate']) : null,
      pumpLabourCharge: (map['pumpLabourCharge'] ?? 0.0).toDouble(),
      nozzleLabourCharge: (map['nozzleLabourCharge'] ?? 0.0).toDouble(),
      otherCharges: (map['otherCharges'] ?? 0.0).toDouble(),
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

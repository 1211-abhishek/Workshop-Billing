import 'package:flutter/material.dart';
import '../models/billing_history.dart';

class BillWidgetPreview extends StatelessWidget {
  final BillingHistory billingHistory;
  const BillWidgetPreview({super.key, required this.billingHistory});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const padding = 16.0;
    const dividerHeight = 24.0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(padding / 2),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('SHIVAM BOSCH PUMP SERVICE', style: textTheme.titleLarge),
              const SizedBox(height: padding / 8),
              Text('(Bosch Pump Service Center)', style: textTheme.bodySmall),
              const SizedBox(height: padding / 4),
              Text('Tembhurni Bypass Road, Mahadeonagar,\nAKLUJ-413101 Tel.Malshiras,Dist.Solapur Mob. 9960074484', style: textTheme.bodySmall),
              const Divider(height: dividerHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CUSTOMER DETAILS', style: textTheme.labelLarge),
                        Text('Name:${billingHistory.customerName ?? '-'}', style: textTheme.bodyMedium),
                        Text('Contact: ${billingHistory.customerContact ?? '-'}', style: textTheme.bodyMedium),
                        Text('Address: ${billingHistory.customerAddress ?? '-'}', style: textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text('MACHINE INFO', style: textTheme.labelLarge),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Serial No: ${billingHistory.serialNumber ?? '-'}', style: textTheme.bodyMedium),
                                  Text('Engine Type: ${billingHistory.engineType ?? '-'}', style: textTheme.bodyMedium),
                                  Text('Pump: ${billingHistory.pump ?? '-'}', style: textTheme.bodyMedium),
                                  Text('Governor: ${billingHistory.governor ?? '-'}', style: textTheme.bodyMedium),
                                  Text('Feed Pump: ${billingHistory.feedPump ?? '-'}', style: textTheme.bodyMedium),
                                  Text('Noozel Holder: ${billingHistory.noozelHolder ?? '-'}', style: textTheme.bodyMedium),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Vehicle No: ${billingHistory.vehicleNumber ?? '-'}', style: textTheme.bodyMedium),
                                  Text('Mechanic: ${billingHistory.mechanicName ?? '-'}', style: textTheme.bodyMedium),
                                  Text('Arrived: ${billingHistory.arrivedDate != null ? '${billingHistory.arrivedDate!.day}/${billingHistory.arrivedDate!.month}/${billingHistory.arrivedDate!.year}' : '-'}', style: textTheme.bodyMedium),
                                  Text('Delivered: ${billingHistory.deliveredDate != null ? '${billingHistory.deliveredDate!.day}/${billingHistory.deliveredDate!.month}/${billingHistory.deliveredDate!.year}' : '-'}', style: textTheme.bodyMedium),
                                  Text('Billing Date: ${billingHistory.billingDate != null ? '${billingHistory.billingDate!.day}/${billingHistory.billingDate!.month}/${billingHistory.billingDate!.year}' : '-'}', style: textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('INVOICE DETAILS', style: textTheme.labelLarge),
                      Text('Invoice No: ${billingHistory.invoiceNumber}', style: textTheme.bodyMedium),
                      Text('Date: ${billingHistory.date.day}/${billingHistory.date.month}/${billingHistory.date.year}', style: textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
              const Divider(height: dividerHeight),
              DataTable(
                columnSpacing: 8,
                headingRowHeight: 24,
                dataRowMinHeight: 20,
                dataRowMaxHeight: 24,
                columns: [
                  DataColumn(label: Text('S.No.', style: textTheme.labelLarge)),
                  DataColumn(label: Text('PART NAME', style: textTheme.labelLarge)),
                  DataColumn(label: Text('QTY', style: textTheme.labelLarge)),
                  DataColumn(label: Text('RATE', style: textTheme.labelLarge)),
                  DataColumn(label: Text('TOTAL', style: textTheme.labelLarge)),
                ],
                rows: [
                  for (int i = 0; i < billingHistory.items.length; i++)
                    DataRow(cells: [
                      DataCell(Text('${i + 1}', style: textTheme.bodySmall)),
                      DataCell(Text(billingHistory.items[i].productName, style: textTheme.bodySmall)),
                      DataCell(Text('${billingHistory.items[i].quantity} ${billingHistory.items[i].unit ?? ''}', style: textTheme.bodySmall)),
                      DataCell(Text('₹${billingHistory.items[i].unitPrice.toStringAsFixed(2)}', style: textTheme.bodySmall)),
                      DataCell(Text('₹${billingHistory.items[i].totalPrice.toStringAsFixed(2)}', style: textTheme.bodySmall)),
                    ]),
                ],
              ),
              const Divider(height: dividerHeight),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Subtotal: ₹${(billingHistory.totalAmount + billingHistory.discountAmount - billingHistory.taxAmount).toStringAsFixed(2)}', style: textTheme.bodyMedium),
                    if (billingHistory.discountAmount > 0)
                      Text('Discount: -₹${billingHistory.discountAmount.toStringAsFixed(2)}', style: textTheme.bodyMedium),
                    if (billingHistory.taxAmount > 0)
                      Text('Tax: ₹${billingHistory.taxAmount.toStringAsFixed(2)}', style: textTheme.bodyMedium),
                    if (billingHistory.pumpLabourCharge != null && billingHistory.pumpLabourCharge! > 0)
                      Text('Labour (Pump): ₹${billingHistory.pumpLabourCharge!.toStringAsFixed(2)}', style: textTheme.bodyMedium),
                    if (billingHistory.nozzleLabourCharge != null && billingHistory.nozzleLabourCharge! > 0)
                      Text('Labour (Nozzle): ₹${billingHistory.nozzleLabourCharge!.toStringAsFixed(2)}', style: textTheme.bodyMedium),
                    if (billingHistory.otherCharges != null && billingHistory.otherCharges! > 0)
                      Text('Other Charges: ₹${billingHistory.otherCharges!.toStringAsFixed(2)}', style: textTheme.bodyMedium),
                    Text('GRAND TOTAL: ₹${billingHistory.totalAmount.toStringAsFixed(2)}', style: textTheme.titleMedium),
                  ],
                ),
              ),
              const Divider(height: dividerHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DELIVERED', style: textTheme.bodyMedium),
                      const SizedBox(height: padding / 2),
                      Text('DATE: ___________', style: textTheme.bodyMedium),
                      const SizedBox(height: padding / 4),
                      Text('SIGN: ___________', style: textTheme.bodyMedium),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("CUSTOMER'S SIGN", style: textTheme.bodyMedium),
                      const SizedBox(height: padding),
                      Text('For: SHIVAM BOSCH PUMP SERVICE', style: textTheme.bodyMedium),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

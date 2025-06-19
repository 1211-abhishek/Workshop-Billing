import 'package:flutter/material.dart';
import '../models/billing_history.dart';
import '../responsive_layout.dart';

class BillWidgetPreview extends StatelessWidget {
  final BillingHistory billingHistory;
  const BillWidgetPreview({super.key, required this.billingHistory});

  @override
  Widget build(BuildContext context) {
    // Responsive font and padding
    double headerFont = 20, subHeaderFont = 12, bodyFont = 11, tableFont = 11, totalFont = 14, padding = 16, dividerHeight = 24;
    if (ResponsiveLayout.isMobile(context)) {
      headerFont = 15; subHeaderFont = 9; bodyFont = 9; tableFont = 9; totalFont = 11; padding = 8; dividerHeight = 12;
    } else if (ResponsiveLayout.isTablet(context)) {
      headerFont = 17; subHeaderFont = 10; bodyFont = 10; tableFont = 10; totalFont = 12; padding = 12; dividerHeight = 18;
    }
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(padding / 2),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text('SHIVAM BOSCH PUMP SERVICE', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: headerFont)),
              SizedBox(height: padding / 8),
              Text('(Bosch Pump Service Center)', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: subHeaderFont)),
              SizedBox(height: padding / 4),
              Text('Tembhurni Bypass Road, Mahadeonagar,\nAKLUJ-413101 Tel.Malshiras,Dist.Solapur Mob. 9960074484', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: subHeaderFont)),
              Divider(height: dividerHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CUSTOMER DETAILS', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: bodyFont, fontWeight: FontWeight.bold)),
                      Text('Name:${billingHistory.customerName ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                      Text('Contact: ${billingHistory.customerContact ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                      Text('Address: ${billingHistory.customerAddress ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                      const SizedBox(height: 8),
                      Text('MACHINE INFO', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: bodyFont, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Serial No: ${billingHistory.serialNumber ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Engine Type: ${billingHistory.engineType ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Pump: ${billingHistory.pump ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Governor: ${billingHistory.governor ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Feed Pump: ${billingHistory.feedPump ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Noozel Holder: ${billingHistory.noozelHolder ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vehicle No: ${billingHistory.vehicleNumber ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Mechanic: ${billingHistory.mechanicName ?? '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Arrived: ${billingHistory.arrivedDate != null ? '${billingHistory.arrivedDate!.day}/${billingHistory.arrivedDate!.month}/${billingHistory.arrivedDate!.year}' : '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Delivered: ${billingHistory.deliveredDate != null ? '${billingHistory.deliveredDate!.day}/${billingHistory.deliveredDate!.month}/${billingHistory.deliveredDate!.year}' : '-'}', style: TextStyle(fontSize: bodyFont)),
                              Text('Billing Date: ${billingHistory.billingDate != null ? '${billingHistory.billingDate!.day}/${billingHistory.billingDate!.month}/${billingHistory.billingDate!.year}' : '-'}', style: TextStyle(fontSize: bodyFont)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('INVOICE DETAILS', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: bodyFont, fontWeight: FontWeight.bold)),
                      Text('Invoice No: ${billingHistory.invoiceNumber}', style: TextStyle(fontSize: bodyFont)),
                      Text('Date: ${billingHistory.date.day}/${billingHistory.date.month}/${billingHistory.date.year}', style: TextStyle(fontSize: bodyFont)),
                    ],
                  ),
                ],
              ),
              Divider(height: dividerHeight),
              DataTable(
                columnSpacing: 8,
                headingRowHeight: 24,
                dataRowMinHeight: 20,
                dataRowMaxHeight: 24,
                columns: [
                  DataColumn(label: Text('S.No.', style: TextStyle(fontSize: tableFont, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('PART NAME', style: TextStyle(fontSize: tableFont, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('QTY', style: TextStyle(fontSize: tableFont, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('RATE', style: TextStyle(fontSize: tableFont, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('TOTAL', style: TextStyle(fontSize: tableFont, fontWeight: FontWeight.bold))),
                ],
                rows: [
                  for (int i = 0; i < billingHistory.items.length; i++)
                    DataRow(cells: [
                      DataCell(Text('${i + 1}', style: TextStyle(fontSize: tableFont))),
                      DataCell(Text(billingHistory.items[i].productName, style: TextStyle(fontSize: tableFont))),
                      DataCell(Text('${billingHistory.items[i].quantity} ${billingHistory.items[i].unit ?? ''}', style: TextStyle(fontSize: tableFont))),
                      DataCell(Text('₹${billingHistory.items[i].unitPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: tableFont))),
                      DataCell(Text('₹${billingHistory.items[i].totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: tableFont))),
                    ]),
                ],
              ),
              Divider(height: dividerHeight),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Subtotal: ₹${(billingHistory.totalAmount + billingHistory.discountAmount - billingHistory.taxAmount).toStringAsFixed(2)}', style: TextStyle(fontSize: bodyFont)),
                    if (billingHistory.discountAmount > 0)
                      Text('Discount: -₹${billingHistory.discountAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: bodyFont)),
                    if (billingHistory.taxAmount > 0)
                      Text('Tax: ₹${billingHistory.taxAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: bodyFont)),
                    if (billingHistory.pumpLabourCharge != null && billingHistory.pumpLabourCharge! > 0)
                      Text('Labour (Pump): ₹${billingHistory.pumpLabourCharge!.toStringAsFixed(2)}', style: TextStyle(fontSize: bodyFont)),
                    if (billingHistory.nozzleLabourCharge != null && billingHistory.nozzleLabourCharge! > 0)
                      Text('Labour (Nozzle): ₹${billingHistory.nozzleLabourCharge!.toStringAsFixed(2)}', style: TextStyle(fontSize: bodyFont)),
                    if (billingHistory.otherCharges != null && billingHistory.otherCharges! > 0)
                      Text('Other Charges: ₹${billingHistory.otherCharges!.toStringAsFixed(2)}', style: TextStyle(fontSize: bodyFont)),
                    Text('GRAND TOTAL: ₹${billingHistory.totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: totalFont, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Divider(height: dividerHeight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DELIVERED', style: TextStyle(fontSize: bodyFont)),
                      SizedBox(height: padding / 2),
                      Text('DATE: ___________', style: TextStyle(fontSize: bodyFont)),
                      SizedBox(height: padding / 4),
                      Text('SIGN: ___________', style: TextStyle(fontSize: bodyFont)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("CUSTOMER'S SIGN", style: TextStyle(fontSize: bodyFont)),
                      SizedBox(height: padding),
                      Text('For: SHIVAM BOSCH PUMP SERVICE', style: TextStyle(fontSize: bodyFont)),
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

import 'package:flutter/material.dart';
import '../models/billing_history.dart';

class BillWidgetPreview extends StatelessWidget {
  final BillingHistory billingHistory;
  const BillWidgetPreview({super.key, required this.billingHistory});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SHIVAM BOSCH PUMP SERVICE', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('(Bosch Pump Service Center)', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text('Tembhurni Bypass Road, Mahadeonagar,\nAKLUJ-413101 Tel.Malshiras,Dist.Solapur Mob. 9960074484', style: Theme.of(context).textTheme.bodySmall),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CUSTOMER DETAILS', style: Theme.of(context).textTheme.labelLarge),
                    if (billingHistory.customerName != null) Text('Name: ${billingHistory.customerName}'),
                    if (billingHistory.customerContact != null) Text('Contact: ${billingHistory.customerContact}'),
                    if (billingHistory.customerAddress != null) Text('Address: ${billingHistory.customerAddress}'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('INVOICE DETAILS', style: Theme.of(context).textTheme.labelLarge),
                    Text('Invoice No: ${billingHistory.invoiceNumber}'),
                    Text('Date: ${billingHistory.date.day}/${billingHistory.date.month}/${billingHistory.date.year}'),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            DataTable(
              columns: const [
                DataColumn(label: Text('S.No.')),
                DataColumn(label: Text('PART NAME')),
                DataColumn(label: Text('QTY')),
                DataColumn(label: Text('RATE')),
                DataColumn(label: Text('TOTAL')),
              ],
              rows: [
                for (int i = 0; i < billingHistory.items.length; i++)
                  DataRow(cells: [
                    DataCell(Text('${i + 1}')),
                    DataCell(Text(billingHistory.items[i].productName)),
                    DataCell(Text('${billingHistory.items[i].quantity} ${billingHistory.items[i].unit ?? ''}')),
                    DataCell(Text('₹${billingHistory.items[i].unitPrice.toStringAsFixed(2)}')),
                    DataCell(Text('₹${billingHistory.items[i].totalPrice.toStringAsFixed(2)}')),
                  ]),
              ],
            ),
            const Divider(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Subtotal: ₹${(billingHistory.totalAmount + billingHistory.discountAmount - billingHistory.taxAmount).toStringAsFixed(2)}'),
                  if (billingHistory.discountAmount > 0)
                    Text('Discount: -₹${billingHistory.discountAmount.toStringAsFixed(2)}'),
                  if (billingHistory.taxAmount > 0)
                    Text('Tax: ₹${billingHistory.taxAmount.toStringAsFixed(2)}'),
                  Text('GRAND TOTAL: ₹${billingHistory.totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DELIVERED'),
                    const SizedBox(height: 20),
                    Text('DATE: ___________'),
                    const SizedBox(height: 10),
                    Text('SIGN: ___________'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("CUSTOMER'S SIGN"),
                    const SizedBox(height: 40),
                    Text('For: SHIVAM BOSCH PUMP SERVICE'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

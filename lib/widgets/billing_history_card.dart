import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/billing_history.dart';
import '../screens/pdf_invoice_screen.dart';

class BillingHistoryCard extends StatelessWidget {
  final BillingHistory billing;

  const BillingHistoryCard({
    super.key,
    required this.billing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
        right: 8,
        left: 8,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          billing.invoiceNumber,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy - hh:mm a').format(billing.date),
            ),
            if (billing.customerName != null) ...[
              const SizedBox(height: 2),
              Text('Customer: ${billing.customerName}'),
            ],
            const SizedBox(height: 4),
            Text(
              '₹${billing.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.visibility_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PdfInvoiceScreen(
                  billingHistory: billing,
                ),
              ),
            );
          },
          tooltip: 'View Invoice',
        ),
      ),
    );
  }
}

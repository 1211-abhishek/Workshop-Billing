import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_billing_system/providers/billing_history_provider.dart';
import 'bill_preview_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch history when the screen loads
    Provider.of<BillingHistoryProvider>(context, listen: false).fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing History & Reports'),
      ),
      body: Consumer<BillingHistoryProvider>(
        builder: (context, historyProvider, child) {
          if (historyProvider.history.isEmpty) {
            return const Center(
              child: Text(
                'No billing records found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final double totalSales = historyProvider.history.fold(0.0, (sum, item) => sum + item.totalAmount);
          final int totalInvoices = historyProvider.history.length;

          return Column(
            children: [
              // Summary Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sales Summary',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem(
                              context,
                              'Total Sales',
                              NumberFormat.currency(symbol: '₹').format(totalSales),
                            ),
                            _buildSummaryItem(
                              context,
                              'Total Invoices',
                              totalInvoices.toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // History List
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Text(
                  'All Invoices',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: historyProvider.history.length,
                  itemBuilder: (context, index) {
                    final historyItem = historyProvider.history[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Invoice #${historyItem.invoiceNumber}'),
                        subtitle: Text(
                          'Customer: ${historyItem.customerName}\n${DateFormat.yMMMd().add_jm().format(historyItem.date)}',
                        ),
                        trailing: Text(
                          NumberFormat.currency(symbol: '₹').format(historyItem.totalAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BillPreviewScreen(billingHistory: historyItem),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

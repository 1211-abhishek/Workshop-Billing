import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_billing_system/models/billing_history.dart';

class BillingHistoryScreenTablet extends StatelessWidget {
  final List<BillingHistory> billingHistory;
  final List<BillingHistory> filteredHistory;
  final bool isLoading;
  final TextEditingController searchController;
  final DateTimeRange? selectedDateRange;
  final VoidCallback selectDateRange;
  final VoidCallback clearDateFilter;
  final double totalRevenue;

  const BillingHistoryScreenTablet({
    super.key,
    required this.billingHistory,
    required this.filteredHistory,
    required this.isLoading,
    required this.searchController,
    required this.selectedDateRange,
    required this.selectDateRange,
    required this.clearDateFilter,
    required this.totalRevenue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search by invoice, customer...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Text(
                selectedDateRange == null
                    ? 'All Dates'
                    : '${DateFormat.yMd().format(selectedDateRange!.start)} - ${DateFormat.yMd().format(selectedDateRange!.end)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (selectedDateRange != null)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearDateFilter,
                  tooltip: 'Clear Date Filter',
                ),
              IconButton(
                icon: const Icon(Icons.date_range_rounded),
                onPressed: selectDateRange,
                tooltip: 'Select Date Range',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total Revenue',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '\$${totalRevenue.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filteredHistory.length,
                  itemBuilder: (context, index) {
                    final billing = filteredHistory[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        title: Text(billing.invoiceNumber),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customer: ${billing.customerName ?? 'N/A'} (${billing.customerContact ?? 'N/A'})',
                            ),
                            Text(
                              'Date: ${DateFormat.yMd().format(billing.date)}',
                            ),
                          ],
                        ),
                        trailing: Text(
                          '\$${billing.totalAmount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

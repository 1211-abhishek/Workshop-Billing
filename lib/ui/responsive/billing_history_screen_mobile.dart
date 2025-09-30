import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_billing_system/models/billing_history.dart';

class BillingHistoryScreenMobile extends StatelessWidget {
  final List<BillingHistory> billingHistory;
  final List<BillingHistory> filteredHistory;
  final bool isLoading;
  final TextEditingController searchController;
  final DateTimeRange? selectedDateRange;
  final VoidCallback selectDateRange;
  final VoidCallback clearDateFilter;
  final double totalRevenue;

  const BillingHistoryScreenMobile({
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by invoice, customer...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDateRange == null
                          ? 'All Dates'
                          : '${DateFormat.yMd().format(selectedDateRange!.start)} - ${DateFormat.yMd().format(selectedDateRange!.end)}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Total Revenue: \$${totalRevenue.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: filteredHistory.length,
                  itemBuilder: (context, index) {
                    final billing = filteredHistory[index];
                    return ListTile(
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

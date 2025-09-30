import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/billing_history.dart';
import 'pdf_invoice_screen.dart';
import '../responsive_layout.dart';

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  State<BillingHistoryScreen> createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  List<BillingHistory> billingHistory = [];
  List<BillingHistory> filteredHistory = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadBillingHistory();
    searchController.addListener(_filterHistory);
  }

  Future<void> _loadBillingHistory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final history = await DatabaseHelper.instance.getAllBillingHistory();
      setState(() {
        billingHistory = history;
        filteredHistory = history;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading billing history: $e')),
        );
      }
    }
  }

  void _filterHistory() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredHistory = billingHistory.where((billing) {
        final matchesSearch = billing.invoiceNumber.toLowerCase().contains(query) ||
            (billing.customerName?.toLowerCase().contains(query) ?? false) ||
            (billing.customerContact?.toLowerCase().contains(query) ?? false);
        
        final matchesDate = selectedDateRange == null ||
            (billing.date.isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
             billing.date.isBefore(selectedDateRange!.end.add(const Duration(days: 1))));
        
        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange,
    );
    
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
      _filterHistory();
    }
  }

  void _clearDateFilter() {
    setState(() {
      selectedDateRange = null;
    });
    _filterHistory();
  }

  double get totalRevenue {
    return filteredHistory.fold(0.0, (sum, billing) => sum + billing.totalAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range_rounded),
            onPressed: _selectDateRange,
            tooltip: 'Select Date Range',
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobile(context),
        tablet: _buildTablet(context),
        desktop: _buildDesktop(context),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return _mainContent(context, crossAxisCount: 1);
  }

  Widget _buildTablet(BuildContext context) {
    return _mainContent(context, crossAxisCount: 2);
  }

  Widget _buildDesktop(BuildContext context) {
    return _mainContent(context, crossAxisCount: 3);
  }

  Widget _mainContent(BuildContext context, {required int crossAxisCount}) {
    return Column(
      children: [
        // Summary Card
        if (filteredHistory.isNotEmpty)
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Bills',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '${filteredHistory.length}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Revenue',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          '₹${totalRevenue.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Search and Filter Section
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by invoice, customer...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                ),
              ),
              if (selectedDateRange != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${DateFormat('MMM dd').format(selectedDateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(selectedDateRange!.end)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _clearDateFilter,
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // History List
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            billingHistory.isEmpty ? 'No billing history' : 'No matching records',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            billingHistory.isEmpty 
                                ? 'Create your first bill to see history'
                                : 'Try adjusting your search or date filter',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.count(
                    childAspectRatio: 3,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      crossAxisCount: crossAxisCount,
                      children: filteredHistory.map((billing) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
                          
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withAlpha(25), // Replaced withOpacity
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.receipt_long_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            title: Text(
                              billing.invoiceNumber,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(DateFormat('MMM dd, yyyy - hh:mm a').format(billing.date)),
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
                      }).toList(),
                    ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

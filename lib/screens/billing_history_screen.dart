import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../database/db_helper.dart';
import '../models/billing_history.dart';
import '../ui/responsive/billing_history_screen_desktop.dart';
import '../ui/responsive/billing_history_screen_mobile.dart';
import '../ui/responsive/billing_history_screen_tablet.dart';

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
        final matchesSearch =
            billing.invoiceNumber.toLowerCase().contains(query) ||
                (billing.customerName?.toLowerCase().contains(query) ??
                    false) ||
                (billing.customerContact?.toLowerCase().contains(query) ??
                    false);

        final matchesDate = selectedDateRange == null ||
            (billing.date.isAfter(
                  selectedDateRange!.start.subtract(
                    const Duration(days: 1),
                  ),
                ) &&
                billing.date.isBefore(
                  selectedDateRange!.end.add(const Duration(days: 1)),
                ));

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
    return filteredHistory.fold(
      0.0,
      (sum, billing) => sum + billing.totalAmount,
    );
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
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => BillingHistoryScreenMobile(
          billingHistory: billingHistory,
          filteredHistory: filteredHistory,
          isLoading: isLoading,
          searchController: searchController,
          selectedDateRange: selectedDateRange,
          selectDateRange: _selectDateRange,
          clearDateFilter: _clearDateFilter,
          totalRevenue: totalRevenue,
        ),
        tablet: (BuildContext context) => BillingHistoryScreenTablet(
          billingHistory: billingHistory,
          filteredHistory: filteredHistory,
          isLoading: isLoading,
          searchController: searchController,
          selectedDateRange: selectedDateRange,
          selectDateRange: _selectDateRange,
          clearDateFilter: _clearDateFilter,
          totalRevenue: totalRevenue,
        ),
        desktop: (BuildContext context) => BillingHistoryScreenDesktop(
          billingHistory: billingHistory,
          filteredHistory: filteredHistory,
          isLoading: isLoading,
          searchController: searchController,
          selectedDateRange: selectedDateRange,
          selectDateRange: _selectDateRange,
          clearDateFilter: _clearDateFilter,
          totalRevenue: totalRevenue,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

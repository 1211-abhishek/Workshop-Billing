import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../models/billing_history.dart';
import '../widgets/billing_item_card.dart';
import 'pdf_invoice_screen.dart';
import '../responsive_layout.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<Product> availableProducts = [];
  List<BillingItemData> billingItems = [];
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerContactController = TextEditingController();
  final TextEditingController customerAddressController = TextEditingController();
  final TextEditingController discountController = TextEditingController(text: '0');
  final TextEditingController taxController = TextEditingController(text: '0');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await DatabaseHelper.instance.getBillingProducts();
      if (!mounted) return;
      setState(() {
        availableProducts = products;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  void _addBillingItem() {
    if (availableProducts.isEmpty) return;
    
    setState(() {
      billingItems.add(BillingItemData(
        product: availableProducts.first,
        quantity: 1,
        unitPrice: availableProducts.first.sellingPrice,
      ));
    });
  }

  void _removeBillingItem(int index) {
    setState(() {
      billingItems.removeAt(index);
    });
  }

  void _updateBillingItem(int index, BillingItemData item) {
    setState(() {
      billingItems[index] = item;
    });
  }

  double get subtotal {
    return billingItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get discountAmount {
    return double.tryParse(discountController.text) ?? 0.0;
  }

  double get taxAmount {
    final taxPercent = double.tryParse(taxController.text) ?? 0.0;
    return (subtotal - discountAmount) * taxPercent / 100;
  }

  double get grandTotal {
    return subtotal - discountAmount + taxAmount;
  }

  Future<void> _generateInvoice() async {
    if (billingItems.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    try {
      final invoiceNumber = await DatabaseHelper.instance.generateInvoiceNumber();
      
      final billingHistory = BillingHistory(
        invoiceNumber: invoiceNumber,
        date: DateTime.now(),
        totalAmount: grandTotal,
        taxAmount: taxAmount,
        discountAmount: discountAmount,
        customerName: customerNameController.text.isEmpty ? null : customerNameController.text,
        customerContact: customerContactController.text.isEmpty ? null : customerContactController.text,
        customerAddress: customerAddressController.text.isEmpty ? null : customerAddressController.text,
        items: billingItems.map((item) => BillingItem(
          billingHistoryId: 0, // Will be set by database
          productName: item.product.name,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
          totalPrice: item.totalPrice,
          unit: item.product.unit,
        )).toList(),
      );

      await DatabaseHelper.instance.insertBillingHistory(billingHistory);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfInvoiceScreen(
            billingHistory: billingHistory,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating invoice: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Bill'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: availableProducts.isNotEmpty ? _addBillingItem : null,
            tooltip: 'Add Item',
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
    return Column(
      children: [
        _customerDetails(context),
        _billingItemsWidget(context),
        _summarySection(context),
      ],
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(flex: 2, child: _customerDetails(context)),
        Flexible(flex: 4, child: _billingItemsWidget(context)),
        Flexible(flex: 2, child: _summarySection(context)),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(flex: 2, child: _customerDetails(context)),
        Flexible(flex: 4, child: _billingItemsWidget(context)),
        Flexible(flex: 2, child: _summarySection(context)),
      ],
    );
  }

  Widget _customerDetails(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                prefixIcon: Icon(Icons.person_rounded),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customerContactController,
                    decoration: const InputDecoration(
                      labelText: 'Contact',
                      prefixIcon: Icon(Icons.phone_rounded),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: customerAddressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on_rounded),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingItemsWidget(BuildContext context) {
    return Expanded(
      child: billingItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items added',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add items to the bill',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: billingItems.length,
              itemBuilder: (context, index) {
                return BillingItemCard(
                  item: billingItems[index],
                  availableProducts: availableProducts,
                  onUpdate: (item) => _updateBillingItem(index, item),
                  onRemove: () => _removeBillingItem(index),
                );
              },
            ),
    );
  }

  Widget _summarySection(BuildContext context) {
    if (billingItems.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: discountController,
                    decoration: const InputDecoration(
                      labelText: 'Discount (₹)',
                      prefixIcon: Icon(Icons.discount_rounded),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: taxController,
                    decoration: const InputDecoration(
                      labelText: 'Tax (%)',
                      prefixIcon: Icon(Icons.percent_rounded),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            _buildSummaryRow('Subtotal', subtotal),
            if (discountAmount > 0)
              _buildSummaryRow('Discount', -discountAmount),
            if (taxAmount > 0)
              _buildSummaryRow('Tax', taxAmount),
            const Divider(),
            _buildSummaryRow('Grand Total', grandTotal, isTotal: true),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateInvoice,
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Generate Invoice'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerContactController.dispose();
    customerAddressController.dispose();
    discountController.dispose();
    taxController.dispose();
    super.dispose();
  }
}

class BillingItemData {
  final Product product;
  final int quantity;
  final double unitPrice;

  BillingItemData({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  BillingItemData copyWith({
    Product? product,
    int? quantity,
    double? unitPrice,
  }) {
    return BillingItemData(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}

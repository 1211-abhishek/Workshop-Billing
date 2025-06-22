import 'package:flutter/material.dart';
import 'package:flutter_billing_system/screens/bill_preview_screen.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../models/billing_history.dart';
import '../widgets/billing_item_card.dart';
import '../responsive_layout.dart';
import '../widgets/custom_text_field.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<Product> availableProducts = [];
  List<BillingItemData> billingItems = [];
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerContactController =
      TextEditingController();
  final TextEditingController customerAddressController =
      TextEditingController();
  final TextEditingController discountController = TextEditingController(
    text: '0',
  );
  final TextEditingController taxController = TextEditingController(text: '0');
  final TextEditingController engineTypeController = TextEditingController();
  final TextEditingController pumpController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController governorController = TextEditingController();
  final TextEditingController feedPumpController = TextEditingController();
  final TextEditingController noozelHolderController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController mechanicNameController = TextEditingController();
  final TextEditingController pumpLabourController = TextEditingController();
  final TextEditingController nozzleLabourController = TextEditingController();
  final TextEditingController otherChargesController = TextEditingController();
  DateTime? arrivedDate;
  DateTime? deliveredDate;
  DateTime? billingDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _setSerialNumber();
    _debugPrintBills();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await DatabaseHelper.instance.getBillingProducts();
      if (!mounted) return;
      setState(() {
        availableProducts = products;
        // Initialize billingItems with all products, quantity 0
        billingItems =
            products
                .map(
                  (product) => BillingItemData(
                    product: product,
                    quantity: 0,
                    unitPrice: product.sellingPrice,
                  ),
                )
                .toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
      }
    }
  }

  Future<void> _setSerialNumber() async {
    final nextSerial = await DatabaseHelper.instance.getNextSerialNumber();
    setState(() {
      serialNumberController.text = nextSerial.toString();
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

  double get pumpLabourCharge =>
      double.tryParse(pumpLabourController.text) ?? 0.0;
  double get nozzleLabourCharge =>
      double.tryParse(nozzleLabourController.text) ?? 0.0;
  double get otherCharges =>
      double.tryParse(otherChargesController.text) ?? 0.0;

  double get grandTotal {
    return subtotal -
        discountAmount +
        taxAmount +
        pumpLabourCharge +
        nozzleLabourCharge +
        otherCharges;
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
      final invoiceNumber =
          await DatabaseHelper.instance.generateInvoiceNumber();
      // Only include items with quantity > 0
      final filteredBillingItems =
          billingItems.where((item) => item.quantity > 0).toList();
      final pumpLabour = double.tryParse(pumpLabourController.text) ?? 0.0;
      final nozzleLabour = double.tryParse(nozzleLabourController.text) ?? 0.0;
      final otherCharges = double.tryParse(otherChargesController.text) ?? 0.0;
      final subtotal = filteredBillingItems.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
      final totalAmount =
          subtotal -
          discountAmount +
          taxAmount +
          pumpLabour +
          nozzleLabour +
          otherCharges;
      final billingHistory = BillingHistory(
        invoiceNumber: invoiceNumber,
        date: DateTime.now(),
        totalAmount: totalAmount,
        taxAmount: taxAmount,
        discountAmount: discountAmount,
        customerName:
            customerNameController.text.isEmpty
                ? null
                : customerNameController.text,
        customerContact:
            customerContactController.text.isEmpty
                ? null
                : customerContactController.text,
        customerAddress:
            customerAddressController.text.isEmpty
                ? null
                : customerAddressController.text,
        engineType:
            engineTypeController.text.isEmpty
                ? null
                : engineTypeController.text,
        pump: pumpController.text.isEmpty ? null : pumpController.text,
        serialNumber: serialNumberController.text,
        governor:
            governorController.text.isEmpty ? null : governorController.text,
        feedPump:
            feedPumpController.text.isEmpty ? null : feedPumpController.text,
        noozelHolder:
            noozelHolderController.text.isEmpty
                ? null
                : noozelHolderController.text,
        vehicleNumber:
            vehicleNumberController.text.isEmpty
                ? null
                : vehicleNumberController.text,
        mechanicName:
            mechanicNameController.text.isEmpty
                ? null
                : mechanicNameController.text,
        arrivedDate: arrivedDate,
        deliveredDate: deliveredDate,
        billingDate: billingDate,
        pumpLabourCharge: pumpLabour,
        nozzleLabourCharge: nozzleLabour,
        otherCharges: otherCharges,
        items:
            filteredBillingItems
                .map(
                  (item) => BillingItem(
                    billingHistoryId: 0,
                    productName: item.product.name,
                    quantity: item.quantity,
                    unitPrice: item.unitPrice,
                    totalPrice: item.totalPrice,
                    unit: item.product.unit,
                  ),
                )
                .toList(),
      );

      await DatabaseHelper.instance.insertBillingHistory(billingHistory);
      await _setSerialNumber();

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => BillPreviewScreen(billingHistory: billingHistory),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error generating invoice: $e')));
    }
  }

  Future<void> _debugPrintBills() async {
    final bills = await DatabaseHelper.instance.debugGetAllBills();
    print('[DEBUG] All bills in DB:');
    for (final bill in bills) {
      print(bill);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Bill')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[100], // Subtle background
        child: ResponsiveLayout(
          mobile: _buildMobile(context),
          tablet: _buildTablet(context),
          desktop: _buildDesktop(context),
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            _headerBanner(context),
            _customerDetails(context),
            _billingItemsWidget(context, isMobile: true),
            _summarySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 2, child: _customerDetails(context)),
            const SizedBox(width: 16),
            Flexible(flex: 4, child: _billingItemsWidget(context)),
            const SizedBox(width: 16),
            Flexible(flex: 2, child: _summarySection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1300),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: 2, child: _customerDetails(context)),
            const SizedBox(width: 24),
            Flexible(flex: 4, child: _billingItemsWidget(context)),
            const SizedBox(width: 24),
            Flexible(flex: 2, child: _summarySection(context)),
          ],
        ),
      ),
    );
  }

  Widget _headerBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long_rounded, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Text(
            'Create Bill',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerDetails(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 700, // fixed height for scrollable content
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Serial Number at top, read-only
                CustomTextField(
                  controller: serialNumberController,
                  labelText: 'Serial Number',
                ),
                Text(
                  'Customer Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  controller: customerNameController,
                  labelText: 'Customer Name',
                ),

                CustomTextField(
                  controller: customerContactController,
                  labelText: 'Contact',
                  keyboardType: TextInputType.phone,
                ),

                CustomTextField(
                  controller: customerAddressController,
                  labelText: 'Address',
                  maxLines: 2,
                ),
                const SizedBox(height: 15),
                Text(
                  'Machine Info',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                CustomTextField(
                  controller: engineTypeController,
                  labelText: 'Engine Type',
                ),

                CustomTextField(controller: pumpController, labelText: 'Pump'),

                CustomTextField(
                  controller: governorController,
                  labelText: 'Governor',
                ),

                CustomTextField(
                  controller: feedPumpController,
                  labelText: 'Feed Pump',
                ),

                CustomTextField(
                  controller: noozelHolderController,
                  labelText: 'Noozel Holder',
                ),

                CustomTextField(
                  controller: vehicleNumberController,
                  labelText: 'Vehicle Number',
                ),

                CustomTextField(
                  controller: mechanicNameController,
                  labelText: 'Mechanic Name',
                ),

                Row(
                  children: [
                    Expanded(
                      child: _datePickerField(
                        context,
                        label: 'Arrived Date',
                        date: arrivedDate,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: arrivedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => arrivedDate = picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _datePickerField(
                        context,
                        label: 'Delivered Date',
                        date: deliveredDate,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: deliveredDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => deliveredDate = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                _datePickerField(
                  context,
                  label: 'Billing Date',
                  date: billingDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: billingDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => billingDate = picked);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _datePickerField(
    BuildContext context, {
    required String label,
    DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: CustomTextField(
          labelText: label,

          controller: TextEditingController(
            text: date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
          ),
        ),
      ),
    );
  }

  Widget _billingItemsWidget(BuildContext context, {bool isMobile = false}) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: isMobile ? 300 : 700,
          child:
              billingItems.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),

                        Text(
                          'No products available',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    itemCount: billingItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: BillingItemCard(
                          index: index,
                          item: billingItems[index],
                          availableProducts: availableProducts,
                          onUpdate: (item) => _updateBillingItem(index, item),
                          onRemove: () {},
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  Widget _summarySection(BuildContext context) {
    if (billingItems.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          //spacing: 15,
          children: [
            // Labour and other charges fields
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: pumpLabourController,
                    labelText: 'Labour Charge (Pump)',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: nozzleLabourController,
                    labelText: 'Labour Charge (Nozzle)',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            CustomTextField(
              controller: otherChargesController,
              labelText: 'Other Charges',
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: discountController,
                    labelText: 'Discount (₹)',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: taxController,
                    labelText: 'Tax (%)',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            _buildSummaryRow('Subtotal', subtotal),
            if (pumpLabourCharge > 0)
              _buildSummaryRow('Labour Charge (Pump)', pumpLabourCharge),
            if (nozzleLabourCharge > 0)
              _buildSummaryRow('Labour Charge (Nozzle)', nozzleLabourCharge),
            if (otherCharges > 0)
              _buildSummaryRow('Other Charges', otherCharges),
            if (discountAmount > 0)
              _buildSummaryRow('Discount', -discountAmount),
            if (taxAmount > 0) _buildSummaryRow('Tax', taxAmount),
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 0),
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
    engineTypeController.dispose();
    pumpController.dispose();
    serialNumberController.dispose();
    governorController.dispose();
    feedPumpController.dispose();
    noozelHolderController.dispose();
    vehicleNumberController.dispose();
    mechanicNameController.dispose();
    pumpLabourController.dispose();
    nozzleLabourController.dispose();
    otherChargesController.dispose();
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

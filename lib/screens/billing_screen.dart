import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_item_data.dart';
import 'package:flutter_billing_system/screens/bill_preview_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../models/billing_history.dart';
import '../providers/billing_provider.dart';
import 'package:logging/logging.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../ui/responsive/billing_screen_desktop.dart';
import '../ui/responsive/billing_screen_mobile.dart';
import '../ui/responsive/billing_screen_tablet.dart';

final _log = Logger('BillingScreen');

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<Product> availableProducts = [];
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

  double get discountAmount {
    return double.tryParse(discountController.text) ?? 0.0;
  }

  double get taxAmount {
    final subtotal = Provider.of<BillingProvider>(context, listen: false).subtotal;
    final taxPercent = double.tryParse(taxController.text) ?? 0.0;
    return (subtotal - discountAmount) * taxPercent / 100;
  }

  double get pumpLabourCharge =>
      double.tryParse(pumpLabourController.text) ?? 0.0;
  double get nozzleLabourCharge =>
      double.tryParse(nozzleLabourController.text) ?? 0.0;
  double get otherCharges =>
      double.tryParse(otherChargesController.text) ?? 0.0;

  double getGrandTotal(double subtotal) {
    return subtotal -
        discountAmount +
        taxAmount +
        pumpLabourCharge +
        nozzleLabourCharge +
        otherCharges;
  }

  Future<void> _generateInvoice() async {
    final billingProvider = Provider.of<BillingProvider>(context, listen: false);
    if (billingProvider.items.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      return;
    }

    try {
      final invoiceNumber =
          await DatabaseHelper.instance.generateInvoiceNumber();

      final totalAmount = getGrandTotal(billingProvider.subtotal);
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
        pumpLabourCharge: pumpLabourCharge,
        nozzleLabourCharge: nozzleLabourCharge,
        otherCharges: otherCharges,
        items: billingProvider.items.map((item) {
          return item.toBillingHistoryItem();
        }).toList(),
      );

      await DatabaseHelper.instance.insertBillingHistory(billingHistory);
      await _setSerialNumber();
      billingProvider.clearItems();

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
    _log.info('[DEBUG] All bills in DB:');
    for (final bill in bills) {
      _log.info(bill.toString());
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
        child: ScreenTypeLayout.builder(
          mobile: (BuildContext context) => BillingScreenMobile(
            onGenerateInvoice: _generateInvoice,
            getGrandTotal: getGrandTotal,
            serialNumberController: serialNumberController,
            customerNameController: customerNameController,
            customerContactController: customerContactController,
            customerAddressController: customerAddressController,
            engineTypeController: engineTypeController,
            pumpController: pumpController,
            governorController: governorController,
            feedPumpController: feedPumpController,
            noozelHolderController: noozelHolderController,
            vehicleNumberController: vehicleNumberController,
            mechanicNameController: mechanicNameController,
            arrivedDate: arrivedDate,
            deliveredDate: deliveredDate,
            billingDate: billingDate,
            onArrivedDateChanged: (date) => setState(() => arrivedDate = date),
            onDeliveredDateChanged: (date) =>
                setState(() => deliveredDate = date),
            onBillingDateChanged: (date) => setState(() => billingDate = date),
            availableProducts: availableProducts,
            discountController: discountController,
            taxController: taxController,
            pumpLabourController: pumpLabourController,
            nozzleLabourController: nozzleLabourController,
            otherChargesController: otherChargesController,
          ),
          tablet: (BuildContext context) => BillingScreenTablet(
            onGenerateInvoice: _generateInvoice,
            getGrandTotal: getGrandTotal,
            serialNumberController: serialNumberController,
            customerNameController: customerNameController,
            customerContactController: customerContactController,
            customerAddressController: customerAddressController,
            engineTypeController: engineTypeController,
            pumpController: pumpController,
            governorController: governorController,
            feedPumpController: feedPumpController,
            noozelHolderController: noozelHolderController,
            vehicleNumberController: vehicleNumberController,
            mechanicNameController: mechanicNameController,
            arrivedDate: arrivedDate,
            deliveredDate: deliveredDate,
            billingDate: billingDate,
            onArrivedDateChanged: (date) => setState(() => arrivedDate = date),
            onDeliveredDateChanged: (date) =>
                setState(() => deliveredDate = date),
            onBillingDateChanged: (date) => setState(() => billingDate = date),
            availableProducts: availableProducts,
            discountController: discountController,
            taxController: taxController,
            pumpLabourController: pumpLabourController,
            nozzleLabourController: nozzleLabourController,
            otherChargesController: otherChargesController,
          ),
          desktop: (BuildContext context) => BillingScreenDesktop(
            onGenerateInvoice: _generateInvoice,
            getGrandTotal: getGrandTotal,
            serialNumberController: serialNumberController,
            customerNameController: customerNameController,
            customerContactController: customerContactController,
            customerAddressController: customerAddressController,
            engineTypeController: engineTypeController,
            pumpController: pumpController,
            governorController: governorController,
            feedPumpController: feedPumpController,
            noozelHolderController: noozelHolderController,
            vehicleNumberController: vehicleNumberController,
            mechanicNameController: mechanicNameController,
            arrivedDate: arrivedDate,
            deliveredDate: deliveredDate,
            billingDate: billingDate,
            onArrivedDateChanged: (date) => setState(() => arrivedDate = date),
            onDeliveredDateChanged: (date) =>
                setState(() => deliveredDate = date),
            onBillingDateChanged: (date) => setState(() => billingDate = date),
            availableProducts: availableProducts,
            discountController: discountController,
            taxController: taxController,
            pumpLabourController: pumpLabourController,
            nozzleLabourController: nozzleLabourController,
            otherChargesController: otherChargesController,
          ),
        ),
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

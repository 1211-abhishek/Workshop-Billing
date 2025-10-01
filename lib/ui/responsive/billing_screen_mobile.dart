import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_item_data.dart';
import 'package:flutter_billing_system/models/product.dart';
import 'package:flutter_billing_system/providers/billing_provider.dart';
import 'package:flutter_billing_system/widgets/billing_item_card.dart';
import 'package:flutter_billing_system/widgets/custom_text_field.dart';
import 'package:flutter_billing_system/widgets/summary_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BillingScreenMobile extends StatefulWidget {
  final Function onGenerateInvoice;
  final Function(double) getGrandTotal;
  final TextEditingController serialNumberController;
  final TextEditingController customerNameController;
  final TextEditingController customerContactController;
  final TextEditingController customerAddressController;
  final TextEditingController engineTypeController;
  final TextEditingController pumpController;
  final TextEditingController governorController;
  final TextEditingController feedPumpController;
  final TextEditingController noozelHolderController;
  final TextEditingController vehicleNumberController;
  final TextEditingController mechanicNameController;
  final DateTime? arrivedDate;
  final DateTime? deliveredDate;
  final DateTime? billingDate;
  final Function(DateTime?) onArrivedDateChanged;
  final Function(DateTime?) onDeliveredDateChanged;
  final Function(DateTime?) onBillingDateChanged;
  final List<Product> availableProducts;
  final TextEditingController discountController;
  final TextEditingController taxController;
  final TextEditingController pumpLabourController;
  final TextEditingController nozzleLabourController;
  final TextEditingController otherChargesController;

  const BillingScreenMobile({
    super.key,
    required this.onGenerateInvoice,
    required this.getGrandTotal,
    required this.serialNumberController,
    required this.customerNameController,
    required this.customerContactController,
    required this.customerAddressController,
    required this.engineTypeController,
    required this.pumpController,
    required this.governorController,
    required this.feedPumpController,
    required this.noozelHolderController,
    required this.vehicleNumberController,
    required this.mechanicNameController,
    required this.arrivedDate,
    required this.deliveredDate,
    required this.billingDate,
    required this.onArrivedDateChanged,
    required this.onDeliveredDateChanged,
    required this.onBillingDateChanged,
    required this.availableProducts,
    required this.discountController,
    required this.taxController,
    required this.pumpLabourController,
    required this.nozzleLabourController,
    required this.otherChargesController,
  });

  @override
  State<BillingScreenMobile> createState() => _BillingScreenMobileState();
}

class _BillingScreenMobileState extends State<BillingScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
        child: Column(
          children: [
            _headerBanner(context),
            _customerDetails(context),
            _billingItemsWidget(context),
            SummaryWidget(
              onGenerateInvoice: widget.onGenerateInvoice,
              getGrandTotal: widget.getGrandTotal,
              discountController: widget.discountController,
              taxController: widget.taxController,
              pumpLabourController: widget.pumpLabourController,
              nozzleLabourController: widget.nozzleLabourController,
              otherChargesController: widget.otherChargesController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long_rounded, color: Colors.white, size: 36.sp),
          SizedBox(width: 16.w),
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
      margin: EdgeInsets.all(16.w),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SizedBox(
        height: 700.h, // fixed height for scrollable content
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Serial Number at top, read-only
                CustomTextField(
                  controller: widget.serialNumberController,
                  labelText: 'Serial Number',
                ),
                SizedBox(height: 15.h),
                Text(
                  'Customer Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: widget.customerNameController,
                  labelText: 'Customer Name',
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: widget.customerContactController,
                  labelText: 'Contact',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: widget.customerAddressController,
                  labelText: 'Address',
                  maxLines: 2,
                ),
                SizedBox(height: 15.h),
                Text(
                  'Machine Info',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  controller: widget.engineTypeController,
                  labelText: 'Engine Type',
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                    controller: widget.pumpController, labelText: 'Pump'),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: widget.governorController,
                  labelText: 'Governor',
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: widget.feedPumpController,
                  labelText: 'Feed Pump',
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: widget.noozelHolderController,
                  labelText: 'Noozel Holder',
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: widget.vehicleNumberController,
                  labelText: 'Vehicle Number',
                ),
                SizedBox(height: 15.h),
                CustomTextField(
                  controller: widget.mechanicNameController,
                  labelText: 'Mechanic Name',
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Expanded(
                      child: _datePickerField(
                        context,
                        label: 'Arrived Date',
                        date: widget.arrivedDate,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: widget.arrivedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          widget.onArrivedDateChanged(date);
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _datePickerField(
                        context,
                        label: 'Delivered Date',
                        date: widget.deliveredDate,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: widget.deliveredDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          widget.onDeliveredDateChanged(date);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                _datePickerField(
                  context,
                  label: 'Billing Date',
                  date: widget.billingDate,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: widget.billingDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    widget.onBillingDateChanged(date);
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

  Widget _billingItemsWidget(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.w),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: SizedBox(
          height: 300.h,
          child: Consumer<BillingProvider>(
            builder: (context, billingProvider, child) {
              if (billingProvider.items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64.sp,
                        color: Colors.grey.shade400,
                      ),
                      Text(
                        'No items added',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: billingProvider.items.length + 1,
                itemBuilder: (context, index) {
                  if (index == billingProvider.items.length) {
                    return Padding(
                      padding: EdgeInsets.all(8.w),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showAddProductDialog();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Item'),
                      ),
                    );
                  }
                  final item = billingProvider.items[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: BillingItemCard(
                      item: item,
                      onRemove: () {
                        billingProvider.removeItem(item);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddProductDialog() {
    Product? selectedProduct;
    final quantityController = TextEditingController();
    final unitPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Billing Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Product>(
                items: widget.availableProducts.map((product) {
                  return DropdownMenuItem(value: product, child: Text(product.name));
                }).toList(),
                onChanged: (product) {
                  selectedProduct = product;
                  if (product != null) {
                    unitPriceController.text = product.sellingPrice.toString();
                  }
                },
                decoration: const InputDecoration(labelText: 'Product'),
              ),
              CustomTextField(
                controller: quantityController,
                labelText: 'Quantity',
                keyboardType: TextInputType.number,
              ),
              CustomTextField(
                controller: unitPriceController,
                labelText: 'Unit Price',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedProduct != null) {
                  final quantity = int.tryParse(quantityController.text) ?? 1;
                  final unitPrice =
                      double.tryParse(unitPriceController.text) ??
                          selectedProduct!.sellingPrice;
                  final newItem = BillingItemData(
                    product: selectedProduct!,
                    quantity: quantity,
                    unitPrice: unitPrice,
                  );
                  Provider.of<BillingProvider>(context, listen: false)
                      .addItem(newItem);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

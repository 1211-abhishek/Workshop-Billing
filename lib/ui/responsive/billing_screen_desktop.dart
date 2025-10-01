import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/product.dart';
import 'package:flutter_billing_system/widgets/billing_items_widget.dart';
import 'package:flutter_billing_system/widgets/customer_details_widget.dart';
import 'package:flutter_billing_system/widgets/summary_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BillingScreenDesktop extends StatelessWidget {
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

  const BillingScreenDesktop({
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
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1300.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: CustomerDetailsWidget(
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
                onArrivedDateChanged: onArrivedDateChanged,
                onDeliveredDateChanged: onDeliveredDateChanged,
                onBillingDateChanged: onBillingDateChanged,
              ),
            ),
            SizedBox(width: 24.w),
            Flexible(
              flex: 4,
              child: BillingItemsWidget(availableProducts: availableProducts),
            ),
            SizedBox(width: 24.w),
            Flexible(
              flex: 2,
              child: SummaryWidget(
                onGenerateInvoice: onGenerateInvoice,
                getGrandTotal: getGrandTotal,
                discountController: discountController,
                taxController: taxController,
                pumpLabourController: pumpLabourController,
                nozzleLabourController: nozzleLabourController,
                otherChargesController: otherChargesController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_billing_system/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class CustomerDetailsWidget extends StatelessWidget {
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

  const CustomerDetailsWidget({
    super.key,
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
  });

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Serial Number at top, read-only
                CustomTextField(
                  controller: serialNumberController,
                  labelText: 'Serial Number',
                ),
                const SizedBox(height: 15),
                Text(
                  'Customer Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: customerNameController,
                  labelText: 'Customer Name',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: customerContactController,
                  labelText: 'Contact',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 10),
                CustomTextField(
                  controller: engineTypeController,
                  labelText: 'Engine Type',
                ),
                const SizedBox(height: 15),
                CustomTextField(controller: pumpController, labelText: 'Pump'),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: governorController,
                  labelText: 'Governor',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: feedPumpController,
                  labelText: 'Feed Pump',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: noozelHolderController,
                  labelText: 'Noozel Holder',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: vehicleNumberController,
                  labelText: 'Vehicle Number',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: mechanicNameController,
                  labelText: 'Mechanic Name',
                ),
                const SizedBox(height: 15),
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
                            onArrivedDateChanged(picked);
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
                            onDeliveredDateChanged(picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
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
                    if (picked != null) {
                      onBillingDateChanged(picked);
                    }
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
}

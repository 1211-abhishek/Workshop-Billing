import 'package:flutter/material.dart';
import 'package:flutter_billing_system/providers/billing_provider.dart';
import 'package:flutter_billing_system/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class SummaryWidget extends StatefulWidget {
  final Function onGenerateInvoice;
  final Function(double) getGrandTotal;
  final TextEditingController discountController;
  final TextEditingController taxController;
  final TextEditingController pumpLabourController;
  final TextEditingController nozzleLabourController;
  final TextEditingController otherChargesController;

  const SummaryWidget({
    super.key,
    required this.onGenerateInvoice,
    required this.getGrandTotal,
    required this.discountController,
    required this.taxController,
    required this.pumpLabourController,
    required this.nozzleLabourController,
    required this.otherChargesController,
  });

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BillingProvider>(
      builder: (context, billingProvider, child) {
        if (billingProvider.items.isEmpty) return const SizedBox.shrink();
        final subtotal = billingProvider.subtotal;
        final grandTotal = widget.getGrandTotal(subtotal);
        return Card(
          margin: const EdgeInsets.all(16),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Labour and other charges fields
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: widget.pumpLabourController,
                        labelText: 'Labour Charge (Pump)',
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: widget.nozzleLabourController,
                        labelText: 'Labour Charge (Nozzle)',
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: widget.otherChargesController,
                  labelText: 'Other Charges',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: widget.discountController,
                        labelText: 'Discount (₹)',
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        controller: widget.taxController,
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
                if (double.tryParse(widget.pumpLabourController.text) != null &&
                    double.parse(widget.pumpLabourController.text) > 0)
                  _buildSummaryRow('Labour Charge (Pump)',
                      double.parse(widget.pumpLabourController.text)),
                if (double.tryParse(widget.nozzleLabourController.text) !=
                        null &&
                    double.parse(widget.nozzleLabourController.text) > 0)
                  _buildSummaryRow('Labour Charge (Nozzle)',
                      double.parse(widget.nozzleLabourController.text)),
                if (double.tryParse(widget.otherChargesController.text) !=
                        null &&
                    double.parse(widget.otherChargesController.text) > 0)
                  _buildSummaryRow('Other Charges',
                      double.parse(widget.otherChargesController.text)),
                if (double.tryParse(widget.discountController.text) != null &&
                    double.parse(widget.discountController.text) > 0)
                  _buildSummaryRow(
                      'Discount', -double.parse(widget.discountController.text)),
                if (double.tryParse(widget.taxController.text) != null &&
                    double.parse(widget.taxController.text) > 0)
                  _buildSummaryRow(
                      'Tax', subtotal * double.parse(widget.taxController.text) / 100),
                const Divider(),
                _buildSummaryRow('Grand Total', grandTotal, isTotal: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => widget.onGenerateInvoice(),
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
      },
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
}

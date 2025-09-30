import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_item_data.dart';
import 'package:provider/provider.dart';

import '../providers/billing_provider.dart';

class BillingItemCard extends StatelessWidget {
  final BillingItemData item;
  final VoidCallback onRemove;

  const BillingItemCard({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final billingProvider = Provider.of<BillingProvider>(context, listen: false);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.product.name, style: Theme.of(context).textTheme.titleMedium),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onRemove),
              ],
            ),
            const SizedBox(height: 8),
            Text('Price: ₹${item.unitPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quantity: ${item.quantity}'),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (item.quantity > 1) {
                          final newItem = item.copyWith(quantity: item.quantity - 1);
                          billingProvider.removeItem(item);
                          billingProvider.addItem(newItem);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        final newItem = item.copyWith(quantity: item.quantity + 1);
                        billingProvider.removeItem(item);
                        billingProvider.addItem(newItem);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: ', style: Theme.of(context).textTheme.bodyLarge),
                Text('₹${item.totalPrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

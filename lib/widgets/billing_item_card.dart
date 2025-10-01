import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_item_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
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
            SizedBox(height: 8.h),
            Text('Price: ₹${item.unitPrice.toStringAsFixed(2)}'),
            SizedBox(height: 8.h),
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
            Divider(height: 24.h, thickness: 1.w),
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

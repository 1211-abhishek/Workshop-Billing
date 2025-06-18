import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/billing_screen.dart';

class BillingItemCard extends StatelessWidget {
  final BillingItemData item;
  final List<Product> availableProducts;
  final Function(BillingItemData) onUpdate;
  final VoidCallback onRemove;

  const BillingItemCard({
    super.key,
    required this.item,
    required this.availableProducts,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Name
            Expanded(
              flex: 3,
              child: Text(
                item.product.name,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Quantity Selector
            SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_rounded, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: item.quantity > 1
                        ? () => onUpdate(item.copyWith(quantity: item.quantity - 1))
                        : null,
                  ),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_rounded, size: 18),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => onUpdate(item.copyWith(quantity: item.quantity + 1)),
                  ),
                ],
              ),
            ),
            // Unit Price
            SizedBox(
              width: 80,
              child: TextFormField(
                initialValue: item.unitPrice.toStringAsFixed(2),
                decoration: const InputDecoration(
                  labelText: '₹',
                  labelStyle: TextStyle(fontSize: 12),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final price = double.tryParse(value) ?? item.unitPrice;
                  onUpdate(item.copyWith(unitPrice: price));
                },
              ),
            ),
            // Total
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Total', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  Text(
                    '₹${item.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            // Remove button (optional, can be hidden if not needed)
            // IconButton(
            //   icon: Icon(Icons.delete_rounded, color: Colors.red.shade400, size: 20),
            //   onPressed: onRemove,
            // ),
          ],
        ),
      ),
    );
  }
}

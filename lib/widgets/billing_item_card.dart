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
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: item.product.name,
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Product',
                      
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_rounded),
                  color: Colors.red.shade400,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuantitySelector(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPriceField(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTotalDisplay(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        IconButton(
          onPressed: item.quantity > 1
              ? () => onUpdate(item.copyWith(quantity: item.quantity - 1))
              : null,
          icon: const Icon(Icons.remove_rounded),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            '${item.quantity}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => onUpdate(item.copyWith(quantity: item.quantity + 1)),
          icon: const Icon(Icons.add_rounded),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            foregroundColor: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      initialValue: item.unitPrice.toStringAsFixed(2),
      decoration: const InputDecoration(
        labelText: 'Unit Price',
        prefixText: '₹',
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final price = double.tryParse(value) ?? item.unitPrice;
        onUpdate(item.copyWith(unitPrice: price));
      },
    );
  }

  Widget _buildTotalDisplay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            'Total',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            '₹${item.totalPrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

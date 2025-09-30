import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final Function() onEdit;
  final Function() onDelete;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Product Image (Placeholder)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                image: product.category != null
                    ? DecorationImage(
                        image: AssetImage(
                          'assets/categories/${product.category!.toLowerCase().replaceAll(' ', '_')}.png',
                        ),
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          Colors.grey.shade200.withOpacity(0.5),
                          BlendMode.dstATop,
                        ),
                      )
                    : null,
              ),
              child: product.category == null
                  ? const Icon(Icons.inventory_2_outlined, size: 40)
                  : null,
            ),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description ?? 'No description',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          '${product.quantity} ${product.unit}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: product.quantity < 10
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          product.category ?? 'Uncategorized',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.blue.shade100,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Price and Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${product.sellingPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'BP: ₹${product.buyingPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_rounded, size: 20),
                      onPressed: onEdit,
                      tooltip: 'Edit Product',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, size: 20),
                      onPressed: onDelete,
                      tooltip: 'Delete Product',
                      color: Colors.red.shade400,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

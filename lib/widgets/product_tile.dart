import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleSelection;
  final bool showSelectionToggle;
  

  const ProductTile({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onToggleSelection,
    this.showSelectionToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double cardWidth;
    double iconSize;
    double fontSize;
    if (width < 500) {
      cardWidth = double.infinity;
      iconSize = 32;
      fontSize = 14;
    } else if (width < 800) {
      cardWidth = 350;
      iconSize = 40;
      fontSize = 16;
    } else {
      cardWidth = 350;
      iconSize = 48;
      fontSize = 18;
    }
    return Center(
      child: SizedBox(
        width: cardWidth == double.infinity ? null : cardWidth,
        height: width < 500 ? 100 : width < 800 ? 120 : 130, // Fixed height like CustomCard
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(0),
          elevation: 2,
          shadowColor: Colors.black.withAlpha(25), // Replaced withOpacity
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withAlpha(25), // Replaced withOpacity
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: iconSize,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          if (product.category != null)
                            Text(
                              product.category!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: fontSize - 2,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text('Stock: ${product.quantity} ${product.unit}', style: TextStyle(fontSize: fontSize - 2)),
                              const SizedBox(width: 16),
                              Text('₹${product.sellingPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: fontSize - 2)),
                            ],
                          ),
                          if (product.quantity <= 5)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Low Stock',
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontSize: fontSize - 4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Align(
                      alignment: Alignment.topCenter,
                      child: showSelectionToggle
                          ? Switch(
                              value: product.isSelectedForBilling,
                              onChanged: (_) => onToggleSelection?.call(),
                            )
                          : PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    onEdit?.call();
                                    break;
                                  case 'delete':
                                    onDelete?.call();
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_rounded),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_rounded, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

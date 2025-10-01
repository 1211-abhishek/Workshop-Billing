import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/billing_item_data.dart';
import 'package:flutter_billing_system/models/product.dart';
import 'package:flutter_billing_system/providers/billing_provider.dart';
import 'package:flutter_billing_system/widgets/billing_item_card.dart';
import 'package:flutter_billing_system/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BillingItemsWidget extends StatelessWidget {
  final bool isMobile;
  final List<Product> availableProducts;

  const BillingItemsWidget({
    super.key,
    this.isMobile = false,
    required this.availableProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.w),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: SizedBox(
          height: isMobile ? 300.h : 700.h,
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
                      padding: EdgeInsets.all(8.0.w),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showAddProductDialog(context);
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

  void _showAddProductDialog(BuildContext context) {
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
                items: availableProducts.map((product) {
                  return DropdownMenuItem<Product>(
                    value: product,
                    child: Text(product.name),
                  );
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

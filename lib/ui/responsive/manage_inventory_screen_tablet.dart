import 'package:flutter/material.dart';
import 'package:flutter_billing_system/models/product.dart';

class ManageInventoryScreenTablet extends StatelessWidget {
  final List<Product> products;
  final List<Product> filteredProducts;
  final bool isLoading;
  final TextEditingController searchController;
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategorySelected;
  final Function(Product) onEdit;
  final Function(Product) onDelete;
  final Function onAdd;

  const ManageInventoryScreenTablet({
    super.key,
    required this.products,
    required this.filteredProducts,
    required this.isLoading,
    required this.searchController,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search Products',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (value) => onCategorySelected(value!),
                items: categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Card(
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(product.description ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$${product.sellingPrice.toStringAsFixed(2)}'),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => onEdit(product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => onDelete(product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

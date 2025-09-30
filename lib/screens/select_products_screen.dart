import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../widgets/product_tile.dart';
import '../responsive_layout.dart';

class SelectProductsScreen extends StatefulWidget {
  const SelectProductsScreen({super.key});

  @override
  State<SelectProductsScreen> createState() => _SelectProductsScreenState();
}

class _SelectProductsScreenState extends State<SelectProductsScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  List<String> categories = ['All'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    searchController.addListener(_filterProducts);
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedProducts = await DatabaseHelper.instance.getAllProducts();
      final productCategories =
          loadedProducts
              .map((p) => p.category ?? 'Uncategorized')
              .toSet()
              .toList();

      setState(() {
        products = loadedProducts;
        filteredProducts = loadedProducts;
        categories = ['All', ...productCategories];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
      }
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts =
          products.where((product) {
            final matchesSearch =
                product.name.toLowerCase().contains(query) ||
                (product.description?.toLowerCase().contains(query) ?? false);
            final matchesCategory =
                selectedCategory == 'All' ||
                (product.category ?? 'Uncategorized') == selectedCategory;
            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  Future<void> _toggleProductSelection(Product product) async {
    try {
      final updatedProduct = product.copyWith(
        isSelectedForBilling: !product.isSelectedForBilling,
      );

      await DatabaseHelper.instance.updateProduct(updatedProduct);
      _loadProducts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              updatedProduct.isSelectedForBilling
                  ? '${product.name} added to billing'
                  : '${product.name} removed from billing',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating product: $e')));
      }
    }
  }

  Future<void> _selectAllProducts(bool select) async {
    try {
      for (Product product in filteredProducts) {
        if (product.isSelectedForBilling != select) {
          final updatedProduct = product.copyWith(isSelectedForBilling: select);
          await DatabaseHelper.instance.updateProduct(updatedProduct);
        }
      }
      _loadProducts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              select
                  ? 'All products selected for billing'
                  : 'All products deselected',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating products: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allSelected = filteredProducts.every((p) => p.isSelectedForBilling);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Products'),
        actions: [
          TextButton(
            onPressed: () => _selectAllProducts(!allSelected),
            child: Text(allSelected ? 'Deselect All' : 'Select All'),
          ),
        ],
      ),
      body: ResponsiveLayout(
        mobile: _buildMobile(context),
        tablet: _buildTablet(context),
        desktop: _buildDesktop(context),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return _mainContent(context, crossAxisCount: 1);
  }

  Widget _buildTablet(BuildContext context) {
    return _mainContent(context, crossAxisCount: 2);
  }

  Widget _buildDesktop(BuildContext context) {
    return _mainContent(context, crossAxisCount: 3);
  }

  Widget _mainContent(BuildContext context, {required int crossAxisCount}) {
    final selectedCount =
        filteredProducts.where((p) => p.isSelectedForBilling).length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            // Info Card
            Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$selectedCount products selected for billing',
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Only selected products will appear in the billing screen',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search and Filter Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon:
                          searchController.text.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  searchController.clear();
                                },
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          categories.map((category) {
                            final isSelected = selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                  _filterProducts();
                                },
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Products Grid
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredProducts.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              products.isEmpty
                                  ? 'No products found'
                                  : 'No matching products',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              products.isEmpty
                                  ? 'Add products from inventory management'
                                  : 'Try adjusting your search or filters',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                      : GridView.count(
                        childAspectRatio: 3,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children:
                            filteredProducts.map((product) {
                              return ProductTile(
                                product: product,
                                showSelectionToggle: true,
                                onToggleSelection:
                                    () => _toggleProductSelection(product),
                              );
                            }).toList(),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

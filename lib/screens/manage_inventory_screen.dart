import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../widgets/product_tile.dart';
import 'add_edit_product_screen.dart';
import '../responsive_layout.dart';

class ManageInventoryScreen extends StatefulWidget {
  const ManageInventoryScreen({super.key});

  @override
  State<ManageInventoryScreen> createState() => _ManageInventoryScreenState();
}

class _ManageInventoryScreenState extends State<ManageInventoryScreen> {
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
      final productCategories = loadedProducts
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(query) ||
            (product.description?.toLowerCase().contains(query) ?? false);
        final matchesCategory = selectedCategory == 'All' ||
            (product.category ?? 'Uncategorized') == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await DatabaseHelper.instance.deleteProduct(product.id!);
        _loadProducts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Inventory'),
      ),
      body: ResponsiveLayout(
        mobile: _buildMobile(context),
        tablet: _buildTablet(context),
        desktop: _buildDesktop(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditProductScreen(),
            ),
          );
          if (result == true) {
            _loadProducts();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Product',
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            // Search and Filter Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: searchController.text.isNotEmpty
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
                      children: categories.map((category) {
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

            // Products List
            Expanded(
              child: isLoading
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
                                products.isEmpty ? 'No products found' : 'No matching products',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                products.isEmpty 
                                    ? 'Tap + to add your first product'
                                    : 'Try adjusting your search or filters',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          crossAxisCount: crossAxisCount,
                          children: filteredProducts.map((product) {
                            return ProductTile(
                              product: product,
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditProductScreen(product: product),
                                  ),
                                );
                                if (result == true) {
                                  _loadProducts();
                                }
                              },
                              onDelete: () => _deleteProduct(product),
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

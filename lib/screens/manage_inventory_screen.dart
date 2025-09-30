import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import 'add_edit_product_screen.dart';
import '../ui/responsive/manage_inventory_screen_desktop.dart';
import '../ui/responsive/manage_inventory_screen_mobile.dart';
import '../ui/responsive/manage_inventory_screen_tablet.dart';

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading products: $e')));
      }
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final matchesSearch =
            product.name.toLowerCase().contains(query) ||
                (product.description?.toLowerCase().contains(query) ?? false);
        final matchesCategory = selectedCategory == 'All' ||
            (product.category ?? 'Uncategorized') == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    _filterProducts();
  }

  Future<void> _onEdit(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(
          product: product,
        ),
      ),
    );
    if (result == true) {
      _loadProducts();
    }
  }

  Future<void> _onDelete(Product product) async {
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting product: $e')));
        }
      }
    }
  }

  void _onAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditProductScreen(),
      ),
    );
    if (result == true) {
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Inventory')),
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => ManageInventoryScreenMobile(
          products: products,
          filteredProducts: filteredProducts,
          isLoading: isLoading,
          searchController: searchController,
          selectedCategory: selectedCategory,
          categories: categories,
          onCategorySelected: _onCategorySelected,
          onEdit: _onEdit,
          onDelete: _onDelete,
          onAdd: _onAdd,
        ),
        tablet: (BuildContext context) => ManageInventoryScreenTablet(
          products: products,
          filteredProducts: filteredProducts,
          isLoading: isLoading,
          searchController: searchController,
          selectedCategory: selectedCategory,
          categories: categories,
          onCategorySelected: _onCategorySelected,
          onEdit: _onEdit,
          onDelete: _onDelete,
          onAdd: _onAdd,
        ),
        desktop: (BuildContext context) => ManageInventoryScreenDesktop(
          products: products,
          filteredProducts: filteredProducts,
          isLoading: isLoading,
          searchController: searchController,
          selectedCategory: selectedCategory,
          categories: categories,
          onCategorySelected: _onCategorySelected,
          onEdit: _onEdit,
          onDelete: _onDelete,
          onAdd: _onAdd,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

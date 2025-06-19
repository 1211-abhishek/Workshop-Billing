import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../responsive_layout.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _buyingPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String selectedUnit = 'pcs';
  bool isSelectedForBilling = false;
  bool isLoading = false;

  final List<String> units = ['pcs', 'kg', 'litre', 'meter', 'box', 'set'];
  final List<String> categories = [
    'Pump Parts',
    'Engine Parts',
    'Electrical',
    'Tools',
    'Accessories',
    'Service Items',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final product = widget.product!;
    _nameController.text = product.name;
    _quantityController.text = product.quantity.toString();
    _buyingPriceController.text = product.buyingPrice.toString();
    _sellingPriceController.text = product.sellingPrice.toString();
    _categoryController.text = product.category ?? '';
    _descriptionController.text = product.description ?? '';
    selectedUnit = product.unit ?? 'pcs';
    isSelectedForBilling = product.isSelectedForBilling;
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final product = Product(
        id: widget.product?.id,
        name: _nameController.text.trim(),
        quantity: int.parse(_quantityController.text),
        buyingPrice: double.parse(_buyingPriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        unit: selectedUnit,
        isSelectedForBilling: isSelectedForBilling,
        createdAt: widget.product?.createdAt,
      );

      if (widget.product == null) {
        await DatabaseHelper.instance.insertProduct(product);
      } else {
        await DatabaseHelper.instance.updateProduct(product);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product == null 
                  ? 'Product added successfully' 
                  : 'Product updated successfully'
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving product: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: ResponsiveLayout(
        mobile: _buildForm(context, padding: 16),
        tablet: _buildForm(context, padding: 48),
        desktop: _buildForm(context, padding: 120),
      ),
    );
  }

  Widget _buildForm(BuildContext context, {required double padding}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name *',
                        prefixIcon: Icon(Icons.inventory_2_rounded),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: categories.contains(_categoryController.text) 
                                ? _categoryController.text 
                                : null,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              prefixIcon: Icon(Icons.category_rounded),
                            ),
                            items: categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _categoryController.text = value ?? '';
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedUnit,
                            decoration: const InputDecoration(
                              labelText: 'Unit',
                              prefixIcon: Icon(Icons.straighten_rounded),
                            ),
                            items: units.map((unit) {
                              return DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedUnit = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description_rounded),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory & Pricing',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        prefixIcon: Icon(Icons.numbers_rounded),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter quantity';
                        }
                        if (int.tryParse(value) == null || int.parse(value) < 0) {
                          return 'Please enter valid quantity';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _buyingPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Buying Price *',
                              prefixText: '₹',
                              prefixIcon: Icon(Icons.shopping_cart_rounded),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter buying price';
                              }
                              if (double.tryParse(value) == null || double.parse(value) < 0) {
                                return 'Please enter valid price';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _sellingPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Selling Price *',
                              prefixText: '₹',
                              prefixIcon: Icon(Icons.sell_rounded),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter selling price';
                              }
                              if (double.tryParse(value) == null || double.parse(value) < 0) {
                                return 'Please enter valid price';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Billing Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Show in Billing Screen'),
                      subtitle: const Text('Enable this product for billing'),
                      value: isSelectedForBilling,
                      onChanged: (value) {
                        setState(() {
                          isSelectedForBilling = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveProduct,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(widget.product == null ? 'Save' : 'Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _buyingPriceController.dispose();
    _sellingPriceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

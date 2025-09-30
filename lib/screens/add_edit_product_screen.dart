import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../database/db_helper.dart';
import '../models/product.dart';
import '../ui/responsive/add_edit_product_screen_large.dart';
import '../ui/responsive/add_edit_product_screen_mobile.dart';

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
        category: _categoryController.text.trim().isEmpty
            ? null
            : _categoryController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
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
                  : 'Product updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving product: $e')));
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
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => AddEditProductScreenMobile(
          formKey: _formKey,
          nameController: _nameController,
          quantityController: _quantityController,
          buyingPriceController: _buyingPriceController,
          sellingPriceController: _sellingPriceController,
          categoryController: _categoryController,
          descriptionController: _descriptionController,
          selectedUnit: selectedUnit,
          isSelectedForBilling: isSelectedForBilling,
          isLoading: isLoading,
          units: units,
          categories: categories,
          onUnitChanged: (value) {
            setState(() {
              selectedUnit = value!;
            });
          },
          onCategoryChanged: (value) {
            _categoryController.text = value ?? '';
          },
          onSelectedForBillingChanged: (value) {
            setState(() {
              isSelectedForBilling = value;
            });
          },
          onSave: _saveProduct,
        ),
        tablet: (BuildContext context) => AddEditProductScreenLarge(
          formKey: _formKey,
          nameController: _nameController,
          quantityController: _quantityController,
          buyingPriceController: _buyingPriceController,
          sellingPriceController: _sellingPriceController,
          categoryController: _categoryController,
          descriptionController: _descriptionController,
          selectedUnit: selectedUnit,
          isSelectedForBilling: isSelectedForBilling,
          isLoading: isLoading,
          units: units,
          categories: categories,
          onUnitChanged: (value) {
            setState(() {
              selectedUnit = value!;
            });
          },
          onCategoryChanged: (value) {
            _categoryController.text = value ?? '';
          },
          onSelectedForBillingChanged: (value) {
            setState(() {
              isSelectedForBilling = value;
            });
          },
          onSave: _saveProduct,
        ),
        desktop: (BuildContext context) => AddEditProductScreenLarge(
          formKey: _formKey,
          nameController: _nameController,
          quantityController: _quantityController,
          buyingPriceController: _buyingPriceController,
          sellingPriceController: _sellingPriceController,
          categoryController: _categoryController,
          descriptionController: _descriptionController,
          selectedUnit: selectedUnit,
          isSelectedForBilling: isSelectedForBilling,
          isLoading: isLoading,
          units: units,
          categories: categories,
          onUnitChanged: (value) {
            setState(() {
              selectedUnit = value!;
            });
          },
          onCategoryChanged: (value) {
            _categoryController.text = value ?? '';
          },
          onSelectedForBillingChanged: (value) {
            setState(() {
              isSelectedForBilling = value;
            });
          },
          onSave: _saveProduct,
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

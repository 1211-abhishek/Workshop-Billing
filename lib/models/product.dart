class Product {
  final int? id;
  final String name;
  final int quantity;
  final double buyingPrice;
  final double sellingPrice;
  final bool isSelectedForBilling;
  final String? category;
  final String? description;
  final String? unit;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    required this.buyingPrice,
    required this.sellingPrice,
    this.isSelectedForBilling = false,
    this.category,
    this.description,
    this.unit = 'pcs',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'isSelectedForBilling': isSelectedForBilling ? 1 : 0,
      'category': category,
      'description': description,
      'unit': unit,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      buyingPrice: (map['buyingPrice'] ?? 0.0).toDouble(),
      sellingPrice: (map['sellingPrice'] ?? 0.0).toDouble(),
      isSelectedForBilling: (map['isSelectedForBilling'] ?? 0) == 1,
      category: map['category'],
      description: map['description'],
      unit: map['unit'] ?? 'pcs',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Product copyWith({
    int? id,
    String? name,
    int? quantity,
    double? buyingPrice,
    double? sellingPrice,
    bool? isSelectedForBilling,
    String? category,
    String? description,
    String? unit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      buyingPrice: buyingPrice ?? this.buyingPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      isSelectedForBilling: isSelectedForBilling ?? this.isSelectedForBilling,
      category: category ?? this.category,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

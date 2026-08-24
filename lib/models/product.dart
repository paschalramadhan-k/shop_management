class Product {
  final int? id;
  final String name;
  final String category;
  final double buyingPrice;
  final double sellingPrice;
  final int quantity;
  final String unit;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.unit,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'quantity': quantity,
      'unit': unit,
      'description': description,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      buyingPrice: map['buyingPrice'],
      sellingPrice: map['sellingPrice'],
      quantity: map['quantity'],
      unit: map['unit'],
      description: map['description'],
    );
  }
}
class Sale {
  final int? id;
  final int productId;
  final String productName;
  final String category;

  final int quantity;

  final double buyingPrice;
  final double sellingPrice;

  final double totalBuying;
  final double totalSelling;

  final double profit;

  final String saleDate;

  Sale({
    this.id,
    required this.productId,
    required this.productName,
    required this.category,
    required this.quantity,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.totalBuying,
    required this.totalSelling,
    required this.profit,
    required this.saleDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'category': category,
      'quantity': quantity,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'totalBuying': totalBuying,
      'totalSelling': totalSelling,
      'profit': profit,
      'saleDate': saleDate,
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      category: map['category'],
      quantity: map['quantity'],
      buyingPrice: (map['buyingPrice'] as num).toDouble(),
      sellingPrice: (map['sellingPrice'] as num).toDouble(),
      totalBuying: (map['totalBuying'] as num).toDouble(),
      totalSelling: (map['totalSelling'] as num).toDouble(),
      profit: (map['profit'] as num).toDouble(),
      saleDate: map['saleDate'],
    );
  }
}
class AppSettings {
  final int? id;
  final String shopName;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final String currency;
  final double taxRate;
  final int lowStockLimit;
  final String theme;
  final String receiptFooter;

  AppSettings({
    this.id,
    required this.shopName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.currency,
    required this.taxRate,
    required this.lowStockLimit,
    required this.theme,
    required this.receiptFooter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopName': shopName,
      'ownerName': ownerName,
      'phone': phone,
      'email': email,
      'address': address,
      'currency': currency,
      'taxRate': taxRate,
      'lowStockLimit': lowStockLimit,
      'theme': theme,
      'receiptFooter': receiptFooter,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'],
      shopName: map['shopName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      currency: map['currency'] ?? 'TZS',
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? 0.0,
      lowStockLimit: map['lowStockLimit'] ?? 10,
      theme: map['theme'] ?? 'Light',
      receiptFooter:
      map['receiptFooter'] ?? 'Thank you for shopping with us!',
    );
  }

  AppSettings copyWith({
    int? id,
    String? shopName,
    String? ownerName,
    String? phone,
    String? email,
    String? address,
    String? currency,
    double? taxRate,
    int? lowStockLimit,
    String? theme,
    String? receiptFooter,
  }) {
    return AppSettings(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      currency: currency ?? this.currency,
      taxRate: taxRate ?? this.taxRate,
      lowStockLimit: lowStockLimit ?? this.lowStockLimit,
      theme: theme ?? this.theme,
      receiptFooter: receiptFooter ?? this.receiptFooter,
    );
  }
}
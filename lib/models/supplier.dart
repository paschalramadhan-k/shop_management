class Supplier {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String company;
  final String address;

  Supplier({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.company,
    required this.address,
  });

  Supplier copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? company,
    String? address,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      company: company ?? this.company,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'company': company,
      'address': address,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      company: map['company'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
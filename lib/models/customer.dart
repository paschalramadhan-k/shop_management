class Customer {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;

  Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
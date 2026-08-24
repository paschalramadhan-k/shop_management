class Expense {
  final int? id;
  final String title;
  final String category;
  final double amount;
  final String description;
  final String expenseDate;

  Expense({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.description,
    required this.expenseDate,
  });

  Expense copyWith({
    int? id,
    String? title,
    String? category,
    double? amount,
    String? description,
    String? expenseDate,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      expenseDate: expenseDate ?? this.expenseDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'description': description,
      'expenseDate': expenseDate,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] ?? '',
      expenseDate: map['expenseDate'] ?? '',
    );
  }
}
class TransactionModel {
  final int? id;
  final double total;
  final String paymentMethod;
  final String createdAt;
  final String items;

  TransactionModel({
    this.id,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'payment_method': paymentMethod,
      'created_at': createdAt,
      'items': items,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      total: map['total'],
      paymentMethod: map['payment_method'],
      createdAt: map['created_at'],
      items: map['items'],
    );
  }
}

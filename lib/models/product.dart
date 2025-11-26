class Product {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String category;
  bool isPurchased;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.category,
    this.isPurchased = false,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? category,
    bool? isPurchased,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}

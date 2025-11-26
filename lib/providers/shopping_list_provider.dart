import 'package:shopping_list_app/models/product.dart';

class ShoppingListProvider {
  static final ShoppingListProvider _instance = ShoppingListProvider._internal();

  factory ShoppingListProvider() {
    return _instance;
  }

  ShoppingListProvider._internal();

  List<Product> _products = [
    Product(
      id: '1',
      name: 'Arroz',
      price: 12.50,
      quantity: 2,
      category: 'Alimentos',
    ),
    Product(
      id: '2',
      name: 'Feijão',
      price: 8.00,
      quantity: 1,
      category: 'Alimentos',
    ),
    Product(
      id: '3',
      name: 'Leite',
      price: 5.50,
      quantity: 3,
      category: 'Laticínios',
    ),
    Product(
      id: '4',
      name: 'Pão',
      price: 6.00,
      quantity: 2,
      category: 'Padaria',
    ),
    Product(
      id: '5',
      name: 'Tomate',
      price: 4.50,
      quantity: 1,
      category: 'Frutas e Verduras',
    ),
  ];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  void togglePurchased(String id) {
    final product = _products.firstWhere((p) => p.id == id);
    product.isPurchased = !product.isPurchased;
  }

  double getTotalPrice() {
    return _products.fold(
      0.0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }

  double getPurchasedPrice() {
    return _products
        .where((p) => p.isPurchased)
        .fold(
          0.0,
          (sum, product) => sum + (product.price * product.quantity),
        );
  }

  List<Product> getUnpurchasedProducts() {
    return _products.where((p) => !p.isPurchased).toList();
  }

  List<Product> getPurchasedProducts() {
    return _products.where((p) => p.isPurchased).toList();
  }

  List<String> getCategories() {
    final categories = <String>{};
    for (var product in _products) {
      categories.add(product.category);
    }
    return categories.toList();
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  int getTotalItems() {
    return _products.fold(0, (sum, p) => sum + p.quantity);
  }

  int getPurchasedItems() {
    return _products
        .where((p) => p.isPurchased)
        .fold(0, (sum, p) => sum + p.quantity);
  }

  void clearPurchased() {
    _products.removeWhere((p) => p.isPurchased);
  }
}

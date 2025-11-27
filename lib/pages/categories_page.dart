import 'package:flutter/material.dart';
import 'package:shopping_list_app/providers/shopping_list_provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final provider = ShoppingListProvider();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categories = provider.getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        centerTitle: true,
        elevation: 0,
      ),
      body: selectedCategory == null
          ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final productCount = provider.getProductsByCategory(category).length;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Card(
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade300,
                            Colors.blue.shade600,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getCategoryIcon(category),
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$productCount itens',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : _buildCategoryDetails(selectedCategory!),
    );
  }

  Widget _buildCategoryDetails(String category) {
    final products = provider.getProductsByCategory(category);

    return Column(
      children: [
        AppBar(
          title: Text(category),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                selectedCategory = null;
              });
            },
          ),
          elevation: 0,
        ),
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nenhum produto nesta categoria',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: product.isPurchased,
                          onChanged: (_) {
                            setState(() {
                              provider.togglePurchased(product.id);
                            });
                          },
                        ),
                        title: Text(
                          product.name,
                          style: TextStyle(
                            decoration: product.isPurchased
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text('Qtd: ${product.quantity}'),
                        trailing: Text(
                          'R\$ ${(product.price * product.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Alimentos':
        return Icons.local_grocery_store;
      case 'Laticínios':
        return Icons.emoji_food_beverage;
      case 'Padaria':
        return Icons.bakery_dining;
      case 'Frutas e Verduras':
        return Icons.apple;
      case 'Higiene':
        return Icons.soap;
      default:
        return Icons.shopping_bag;
    }
  }
}

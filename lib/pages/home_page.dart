import 'package:flutter/material.dart';
import 'package:shopping_list_app/models/product.dart';
import 'package:shopping_list_app/providers/shopping_list_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final provider = ShoppingListProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Cards informativos
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total de Itens',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${provider.getTotalItems()}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Valor Total',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'R\$ ${provider.getTotalPrice().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Produtos Pendentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (provider.getUnpurchasedProducts().isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: const [
                      Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'Todos os itens foram comprados!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.getUnpurchasedProducts().length,
                itemBuilder: (context, index) {
                  final product = provider.getUnpurchasedProducts()[index];
                  return ProductCard(
                    product: product,
                    onToggle: () {
                      setState(() {
                        provider.togglePurchased(product.id);
                      });
                    },
                    onEdit: () {
                      _editProduct(context, product);
                    },
                    onDelete: () {
                      setState(() {
                        provider.removeProduct(product.id);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Produto removido')),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProduct(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        onAdd: (name, price, quantity, category) {
          setState(() {
            provider.addProduct(
              Product(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: name,
                price: price,
                quantity: quantity,
                category: category,
              ),
            );
          });
        },
      ),
    );
  }

  void _editProduct(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        product: product,
        onEdit: (name, price, quantity, category) {
          setState(() {
            provider.updateProduct(
              product.copyWith(
                name: name,
                price: price,
                quantity: quantity,
                category: category,
              ),
            );
          });
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: product.isPurchased,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          product.name,
          style: TextStyle(
            decoration: product.isPurchased ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${product.category} • Qtd: ${product.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'R\$ ${(product.price * product.quantity).toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: onEdit,
                  child: const Text('Editar'),
                ),
                PopupMenuItem(
                  onTap: onDelete,
                  child: const Text('Deletar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final Function(String, double, int, String) onAdd;

  const AddProductDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  String selectedCategory = 'Alimentos';

  final categories = ['Alimentos', 'Laticínios', 'Padaria', 'Frutas e Verduras', 'Higiene'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Produto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Preço'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value ?? 'Alimentos';
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nome é obrigatório')),
              );
              return;
            }
            widget.onAdd(
              nameController.text,
              double.tryParse(priceController.text) ?? 0.0,
              int.tryParse(quantityController.text) ?? 1,
              selectedCategory,
            );
            Navigator.pop(context);
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}

class EditProductDialog extends StatefulWidget {
  final Product product;
  final Function(String, double, int, String) onEdit;

  const EditProductDialog({
    Key? key,
    required this.product,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController quantityController;
  late String selectedCategory;

  final categories = ['Alimentos', 'Laticínios', 'Padaria', 'Frutas e Verduras', 'Higiene'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(text: widget.product.price.toString());
    quantityController = TextEditingController(text: widget.product.quantity.toString());
    selectedCategory = widget.product.category;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Produto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Preço'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value ?? 'Alimentos';
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onEdit(
              nameController.text,
              double.tryParse(priceController.text) ?? 0.0,
              int.tryParse(quantityController.text) ?? 1,
              selectedCategory,
            );
            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}

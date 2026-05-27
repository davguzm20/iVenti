import 'package:flutter/material.dart';
import 'package:iventi/features/sales/widgets/CartItemWidget.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';

class CartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double total;
  final Function(int) onDeleteItem;
  final VoidCallback onConfirm;
  final VoidCallback? onAddProduct;

  const CartWidget({
    super.key,
    required this.items,
    required this.total,
    required this.onDeleteItem,
    required this.onConfirm,
    this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onAddProduct != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Agregar producto', style: TextStyle(color: Colors.white)),
              style: ButtonStyles.success(),
              onPressed: onAddProduct,
            ),
          ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: items.isEmpty
                ? const Center(child: Text("No hay productos agregados"))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemWidget(
                        nombre: item['nombre'] ?? '',
                        precio: item['precio'] as double,
                        cantidad: item['cantidad'] as int,
                        subtotal: item['subtotalProducto'] as double,
                        onDelete: () => onDeleteItem(index),
                      );
                    },
                  ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Total: ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: onConfirm,
                style: ButtonStyles.success(borderRadius: 30).copyWith(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
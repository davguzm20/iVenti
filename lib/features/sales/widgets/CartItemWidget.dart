import 'package:flutter/material.dart';
import 'package:iventi/shared/theme/AppColors.dart';

class CartItemWidget extends StatelessWidget {
  final String nombre;
  final double precio;
  final int cantidad;
  final double subtotal;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onQuantityChanged;

  const CartItemWidget({
    super.key,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    required this.subtotal,
    this.onDelete,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 50,
            height: 50,
            child: Image(
              image: AssetImage('lib/assets/iconos/iconoImagen.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Precio: S/ ${precio.toStringAsFixed(2)}"),
                Text("Cantidad: $cantidad"),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Subtotal", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("S/ ${subtotal.toStringAsFixed(2)}"),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
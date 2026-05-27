import 'package:flutter/material.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';

class ProductCard extends StatelessWidget {
  final ProductoEntity product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasLowStock = product.stockActual <= product.stockMinimo;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasLowStock)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Stock Bajo',
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (product.codigo != null && product.codigo!.isNotEmpty)
                Text(
                  'Código: ${product.codigo}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'S/ ${product.precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'Stock: ${product.stockActual}',
                    style: TextStyle(
                      color: hasLowStock ? Colors.red : Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                      tooltip: 'Editar',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Eliminar',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
    final imagen = product.rutaImagen;

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
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: imagen != null
                          ? Image.network(imagen, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Image.asset('lib/assets/iconos/iconoImagen.png', fit: BoxFit.cover))
                          : Image.asset('lib/assets/iconos/iconoImagen.png', fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.nombre,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text('S/ ${product.precio.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text('Stock: ${product.stockActual}',
                              style: TextStyle(fontSize: 12, color: hasLowStock ? Colors.red : Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (hasLowStock)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Stock Bajo',
                        style: TextStyle(color: Colors.red.shade900, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              if (product.codigo != null && product.codigo!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Codigo: ${product.codigo}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null)
                    IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit, tooltip: 'Editar'),
                  if (onDelete != null)
                    IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: onDelete, tooltip: 'Eliminar'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

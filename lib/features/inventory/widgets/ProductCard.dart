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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: (imagen != null && imagen.isNotEmpty)
                      ? Image.network(imagen, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Image.asset('lib/assets/iconos/iconoImagen.png', fit: BoxFit.contain))
                      : Image.asset('lib/assets/iconos/iconoImagen.png', fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 12),
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';

class LoteCard extends StatelessWidget {
  final LoteEntity lote;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const LoteCard({
    super.key,
    required this.lote,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysToExpire = lote.fechaVencimiento.difference(now).inDays;
    final isExpired = daysToExpire < 0;
    final isExpiringSoon = daysToExpire >= 0 && daysToExpire <= 30;

    String expiryStatus;
    Color statusColor;

    if (isExpired) {
      expiryStatus = 'Vencido';
      statusColor = Colors.red;
    } else if (isExpiringSoon) {
      expiryStatus = 'Próximo a Vencer';
      statusColor = Colors.orange;
    } else {
      expiryStatus = 'Vigente';
      statusColor = Colors.green;
    }

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
                      'Lote #${lote.idLote}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      expiryStatus,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Vencimiento: ${lote.fechaVencimiento.day}/${lote.fechaVencimiento.month}/${lote.fechaVencimiento.year}',
                style: TextStyle(
                  color: isExpiringSoon || isExpired ? Colors.red.shade700 : Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cantidad: ${lote.cantidadActual}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'S/ ${lote.precioCompra.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              if (isExpired)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Venció hace ${-daysToExpire} días',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (isExpiringSoon && !isExpired)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Vence en $daysToExpire días',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
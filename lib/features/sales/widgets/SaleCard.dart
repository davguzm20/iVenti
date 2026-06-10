import 'package:flutter/material.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/shared/theme/AppColors.dart';

class SaleCard extends StatelessWidget {
  final VentaEntity venta;
  final VoidCallback onTap;
  final VoidCallback? onDetails;

  const SaleCard({
    super.key,
    required this.venta,
    required this.onTap,
    this.onDetails,
  });

  String _getTipoPago() {
    if (!venta.esCredito) {
      return "Al contado";
    }
    return venta.montoCancelado >= venta.montoTotal
        ? "Crédito (Cancelado)"
        : "Crédito";
  }

  Color _getTipoPagoColor() {
    if (!venta.esCredito) return Colors.black;
    return venta.montoCancelado >= venta.montoTotal
        ? AppColors.success
        : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final tipoPago = _getTipoPago();
    final tipoPagoColor = _getTipoPagoColor();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Venta ${venta.idVenta}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Fecha: ${venta.creadoEn.toIso8601String().split('T')[0]}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      "Monto: S/ ${venta.montoTotal.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      "Tipo de pago: $tipoPago",
                      style: TextStyle(
                        color: tipoPagoColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (onDetails != null)
                Flexible(
                  fit: FlexFit.loose,
                  child: ElevatedButton(
                    onPressed: onDetails,
                    child: const Text("Detalles"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
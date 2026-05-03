import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';

class DetailsSalePage extends StatefulWidget {
  final int idVenta;

  const DetailsSalePage({super.key, required this.idVenta});

  @override
  State<DetailsSalePage> createState() => _DetailsSalePageState();
}

class _DetailsSalePageState extends State<DetailsSalePage> {
  VentaEntity? venta;
  List<DetalleVentaEntity> detalles = [];

  VentaController get _ventaController => context.read<VentaController>();

  @override
  void initState() {
    super.initState();

    _obtenerDatos();
  }

  Future<void> _obtenerDatos() async {
    final v = await _ventaController.obtenerVentaPorId(widget.idVenta);

    if (v != null) {
      final d = await _ventaController.obtenerDetallesDeVenta(widget.idVenta);

      if (mounted) {
        setState(() {
          venta = v;
          detalles = d;
        });
      }

    } else {
      ErrorDialog(
        context: context,
        errorMessage: "No se pudo encontrar la venta.",
      );
    }
  }

  void actualizarMontoCanceladoDialog() {
    final montoACancelarController = TextEditingController();

    if (venta == null) return;

    final montoTotal = venta!.montoTotal;
    final montoCancelado = venta!.montoCancelado;
    final montoPendiente = montoTotal - montoCancelado;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          double montoFaltante = montoPendiente;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Color(0xFF493D9E), width: 2),
            ),
            title: const Text(
              'Cancelar deuda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF493D9E),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow(
                  'Monto total:',
                  'S/ ${montoTotal.toStringAsFixed(2)}',
                ),
                _buildInfoRow(
                  'Monto cancelado:',
                  'S/ ${montoCancelado.toStringAsFixed(2)}',
                ),
                _buildInfoRow(
                  'Monto pendiente:',
                  'S/ ${montoPendiente.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  label: 'Monto a cancelar',
                  controller: montoACancelarController,
                  keyboardType: TextInputType.number,
                  isPrice: true,
                  onChanged: (v) {
                    setDialogState(() {
                      montoFaltante = (montoPendiente -
                              (double.tryParse(v) ?? 0.0))
                          .clamp(0.0, montoPendiente);
                    });
                  },
                ),

                const SizedBox(height: 10),

                _buildInfoRow(
                  'Monto faltante:',
                  'S/ ${montoFaltante.toStringAsFixed(2)}',
                  color: const Color(0xFFE63946),
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2BBF55),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () async {
                    final monto =
                        double.tryParse(montoACancelarController.text) ?? 0.0;

                    if (monto <= 0 || monto > montoPendiente) {
                      ErrorDialog(
                        context: context,
                        errorMessage: 'Monto inválido',
                      );
                      return;
                    }

                    try {
                      await _ventaController.registrarPago(
                        widget.idVenta,
                        monto,
                        1,
                      );

                      if (mounted) {
                        SuccessDialog(
                          context: context,
                          successMessage: 'Monto actualizado correctamente!',
                          btnOkOnPress: () {
                            _obtenerDatos();
                            context.pop();
                          },
                        );
                      }

                    } catch (e) {
                      ErrorDialog(
                        context: context,
                        errorMessage: 'Error al actualizar el monto',
                      );
                    }
                  },
                  child: const Text('Aceptar'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color ?? const Color(0xFF493D9E),
            ),
          ),
          Text(value, style: TextStyle(fontSize: 16, color: color)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (venta != null) ...[
            IconButton(
              icon: Icon(
                Icons.attach_money,
                color: !venta!.esCredito &&
                        venta!.montoCancelado < venta!.montoTotal
                    ? Colors.black
                    : Colors.grey,
              ),
              onPressed: !venta!.esCredito &&
                      venta!.montoCancelado < venta!.montoTotal
                  ? () => actualizarMontoCanceladoDialog()
                  : null,
            ),
          ],
        ],
      ),
      body: venta == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha: ${venta!.creadoEn.toIso8601String().split('T')[0]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF493D9E),
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Hora: ${venta!.creadoEn.toIso8601String().split('T')[1].split('.')[0]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF493D9E),
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Monto total: ${venta!.montoTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF493D9E),
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Monto cancelado: ${venta!.montoCancelado.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF493D9E),
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Tipo: ${venta!.esCredito ? "Crédito" : "Al contado"}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF493D9E),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF493D9E),
                            width: 1.5,
                          ),
                        ),
                        child: Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              width: 1.5,
                              color: Color(0xFF493D9E),
                            ),
                          ),
                          columnWidths: {
                            0: const FlexColumnWidth(0.5),
                            1: const FlexColumnWidth(1.5),
                            2: const FlexColumnWidth(0.6),
                            3: const FlexColumnWidth(0.6),
                          },
                          children: [
                            TableRow(
                              children: [
                                _buildHeader('Ud'),
                                _buildHeader('Descripción'),
                                _buildHeader('Precio'),
                                _buildHeader('Subtotal'),
                              ],
                            ),

                            ...detalles.map(
                              (d) => TableRow(
                                children: [
                                  _buildCell('${d.cantidad}'),
                                  _buildCell('Producto ${d.idLote}'),
                                  _buildCell(
                                      d.precioUnitario.toStringAsFixed(2)),
                                  _buildCell(d.subtotal.toStringAsFixed(2)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF493D9E),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}

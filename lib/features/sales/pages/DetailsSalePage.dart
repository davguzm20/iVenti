import 'package:flutter/material.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/shared/services/PrintService.dart';

class DetailsSalePage extends StatefulWidget {
  final int idVenta;

  const DetailsSalePage({super.key, required this.idVenta});

  @override
  State<DetailsSalePage> createState() => _DetailsSalePageState();
}

class _DetailsSalePageState extends State<DetailsSalePage> {
  VentaEntity? venta;
  List<DetalleVentaEntity> detalles = [];

  VentaController get _ventaController => ServiceLocator.ventaController;

  @override
  void initState() {
    super.initState();

    _obtenerDatos();
  }

  Future<void> _obtenerDatos() async {
    try {
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
        if (!mounted) return;
        final (title, desc) = DialogMessages.ventas.ventaNoEncontrada;
        ErrorDialog(
          context: context,
          title: title,
          description: desc,
        );
      }
    } catch (e) {
      debugPrint('Error al obtener datos de venta: $e');
      if (mounted) {
        ErrorDialog(
          context: context,
          title: 'Error',
          description: 'No se pudieron obtener los datos de la venta',
        );
      }
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
              side: const BorderSide(color: AppColors.primary, width: 2),
            ),
            title: const Text(
              'Cancelar deuda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.primary,
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
                  color: Colors.black87,
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ButtonStyles.success(),
                  onPressed: () async {
                    final monto =
                        double.tryParse(montoACancelarController.text) ?? 0.0;

                    if (monto <= 0) {
                      final (title, desc) = DialogMessages.ventas.montoInvalido;
                      ErrorDialog(
                        context: context,
                        title: title,
                        description: desc,
                      );
                      return;
                    }

                    if (monto > montoPendiente) {
                      final (title, desc) = DialogMessages.ventas.montoExcedido;
                      ErrorDialog(
                        context: context,
                        title: title,
                        description: desc,
                      );
                      return;
                    }

                    try {
                      await _ventaController.registrarPago(
                        widget.idVenta,
                        monto,
                        ServiceLocator.requireUsuarioActualId,
                      );

                      if (context.mounted) {
                        final (title, desc) = DialogMessages.ventas.pagoRegistrado;
                        SuccessDialog(
                          context: context,
                          title: title,
                          description: desc,
                          btnOkOnPress: () {
                            _obtenerDatos();
                            context.pop();
                          },
                        );
                      }

                    } catch (e) {
                      debugPrint('Error al registrar pago: $e');
                      if (!context.mounted) return;
                      final (title, desc) = DialogMessages.ventas.noSePudoRegistrarPago;
                      ErrorDialog(
                        context: context,
                        title: title,
                        description: desc,
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

  Future<void> _generarBoleta() async {
    if (venta == null) return;
    try {
      final path = await PrintService.generarBoletaPDF(
        venta: venta!,
        detalles: detalles,
        clienteNombre: null,
        clienteDni: null,
      );
      if (mounted) {
        await context.push('/pdf-viewer', extra: path);
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: 'Error',
          description: 'No se pudo generar la boleta: $e',
        );
      }
    }
  }

  Future<void> _anularVenta() async {
    if (venta == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Anular venta'),
        content: const Text('Esta accion no se puede deshacer. Deseas anular esta venta?'),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: const Text('Anular', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _ventaController.anularVenta(widget.idVenta);
      if (mounted) {
        SuccessDialog(
          context: context,
          title: 'Venta anulada',
          description: 'La venta se anulo correctamente',
          btnOkOnPress: () => context.pop(),
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog(
          context: context,
          title: 'Error',
          description: 'No se pudo anular la venta: $e',
        );
      }
    }
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
              color: color ?? AppColors.primary,
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
                color: venta!.montoCancelado < venta!.montoTotal
                    ? Colors.black
                    : Colors.grey,
              ),
              onPressed: venta!.montoCancelado < venta!.montoTotal
                  ? () => actualizarMontoCanceladoDialog()
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: () => _generarBoleta(),
            ),
            IconButton(
              icon: const Icon(Icons.block, color: Colors.black),
              onPressed: () => _anularVenta(),
            ),
          ],
        ],
      ),
      body: venta == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
              'Código: ${venta!.codigoBoleta ?? 'Sin código'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),

            Text(
              'Fecha: ${venta!.creadoEn.toIso8601String().split('T')[0]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Hora: ${venta!.creadoEn.toIso8601String().split('T')[1].split('.')[0]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Monto total: S/ ${venta!.montoTotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Monto cancelado: S/ ${venta!.montoCancelado.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Tipo: ${venta!.esCredito ? "Crédito" : "Al contado"}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            'Estado: ${venta!.estado.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
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
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Table(
                          border: TableBorder(
                            horizontalInside: BorderSide(
                              width: 1.5,
                              color: AppColors.primary,
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
          color: AppColors.primary,
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



import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';

class DetailsClientPage extends StatefulWidget {
  final int idCliente;

  const DetailsClientPage({super.key, required this.idCliente});

  @override
  State<DetailsClientPage> createState() => _DetailsClientPageState();
}

class _DetailsClientPageState extends State<DetailsClientPage> {
  ClienteEntity? cliente;
  List<VentaEntity> ventasCliente = [];

  ClienteController get _clienteController =>
      context.read<ClienteController>();
  VentaController get _ventaController => context.read<VentaController>();

  @override
  void initState() {
    super.initState();

    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final c = await _clienteController.obtenerClientePorId(widget.idCliente);
    final v = await _ventaController.obtenerVentasDeCliente(widget.idCliente);

    if (mounted) {
      setState(() {
        cliente = c;
        ventasCliente = v;
      });
    }
  }

  void actualizarMontoCanceladoDialog() async {
    final montoACancelarController = TextEditingController();
    final ventasPendientes =
        ventasCliente.where((v) => v.montoCancelado < v.montoTotal).toList();

    if (ventasPendientes.isEmpty) {
      ErrorDialog(context: context, errorMessage: 'No hay ventas pendientes.');
      return;
    }

    final montoPendiente = ventasPendientes.fold(
      0.0,
      (sum, v) => sum + (v.montoTotal - v.montoCancelado),
    );

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Monto pendiente:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF493D9E),
                      ),
                    ),
                    Text('S/ ${montoPendiente.toStringAsFixed(2)}'),
                  ],
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  label: 'Monto a cancelar',
                  controller: montoACancelarController,
                  keyboardType: TextInputType.number,
                  isPrice: true,
                  onChanged: (value) {
                    final ingresado = double.tryParse(value) ?? 0.0;

                    setDialogState(() {
                      montoFaltante =
                          (montoPendiente - ingresado).clamp(0.0, montoPendiente);
                    });
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Monto faltante:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFE63946),
                      ),
                    ),
                    Text(
                      'S/ ${montoFaltante.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, color: Color(0xFFE63946)),
                    ),
                  ],
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
                      await _ventaController.registrarPagoCliente(
                        widget.idCliente,
                        monto,
                        1,
                      );

                      if (mounted) {
                        SuccessDialog(
                          context: context,
                          successMessage: 'Monto actualizado correctamente!',
                          btnOkOnPress: () {
                            _cargarDatos();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cliente?.nombres ?? "---",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (cliente != null)
            IconButton(
              icon: Icon(
                Icons.attach_money,
                color: cliente!.esDeudor ? Colors.black : Colors.grey,
              ),
              onPressed: cliente!.esDeudor
                  ? () => actualizarMontoCanceladoDialog()
                  : null,
            ),
        ],
      ),
      body: Padding(
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
                      'ID Cliente: ${cliente?.idCliente ?? '---'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF493D9E),
                        fontSize: 18,
                      ),
                    ),

                    Text('DNI: ${cliente?.dni ?? '---'}'),
                    Text('Email: ${cliente?.email ?? '---'}'),
                    Text('Teléfono: ${cliente?.telefono ?? '---'}'),

                    Text(
                      "Estado: ${cliente?.esDeudor == true ? "Deudor" : "Regular"}",
                      style: TextStyle(
                        color: cliente?.esDeudor == true ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Ventas del cliente:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ventasCliente.isEmpty
                  ? const Center(
                      child: Text("No se encontraron ventas"),
                    )
                  : ListView.builder(
                      itemCount: ventasCliente.length,
                      itemBuilder: (context, index) {
                        final venta = ventasCliente[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF493D9E),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Venta ${venta.idVenta}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color(0xFF493D9E),
                                        ),
                                      ),

                                      Text(
                                        "Fecha: ${venta.creadoEn.toIso8601String().split('T')[0]}",
                                      ),

                                      Text(
                                        "Monto: S/ ${venta.montoTotal.toStringAsFixed(2)}",
                                      ),

                                      Text(
                                        "Tipo: ${venta.esCredito ? "Crédito" : "Al contado"}",
                                        style: TextStyle(
                                          color: venta.esCredito &&
                                                  venta.montoCancelado <
                                                      venta.montoTotal
                                              ? Colors.red
                                              : const Color(0xFF2BBF55),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2BBF55),
                                    foregroundColor: Colors.white,
                                    elevation: 6,
                                  ),
                                  onPressed: () => context.push(
                                    '/sales/details-sale/${venta.idVenta}',
                                  ),
                                  child: const Text("Detalles"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

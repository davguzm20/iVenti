import 'package:flutter/material.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';

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
      ServiceLocator.clienteController;
  VentaController get _ventaController => ServiceLocator.ventaController;

  @override
  void initState() {
    super.initState();

    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final c = await _clienteController.obtenerClientePorId(widget.idCliente);
      final v = await _ventaController.obtenerVentasDeCliente(widget.idCliente);

      if (mounted) {
        setState(() {
          cliente = c;
          ventasCliente = v;
        });
      }
    } catch (e) {
      debugPrint('Error al cargar datos del cliente: $e');
      if (mounted) {
        ErrorDialog(
          context: context,
          title: 'Error',
          description: 'No se pudieron cargar los datos del cliente',
        );
      }
    }
  }

  void actualizarMontoCanceladoDialog() async {
    final montoACancelarController = TextEditingController();
    final ventasPendientes =
        ventasCliente.where((v) => v.montoCancelado < v.montoTotal).toList();

    if (ventasPendientes.isEmpty) {
      final (title, desc) = DialogMessages.clientes.sinPagosPendientes;
      ErrorDialog(
        context: context,
        title: title,
        description: desc,
      );
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
                        color: AppColors.primary,
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
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'S/ ${montoFaltante.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
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
                      final (title, desc) = DialogMessages.clientes.montoInvalido;
                      ErrorDialog(
                        context: context,
                        title: title,
                        description: desc,
                      );
                      return;
                    }

                    if (monto > montoPendiente) {
                      final (title, desc) = DialogMessages.clientes.montoExcedido;
                      ErrorDialog(
                        context: context,
                        title: title,
                        description: desc,
                      );
                      return;
                    }

                    try {
                      await _ventaController.registrarPagoCliente(
                        widget.idCliente,
                        monto,
                        ServiceLocator.usuarioActualId!,
                      );

                      if (context.mounted) {
                        final (title, desc) = DialogMessages.clientes.pagoRegistrado;
                        SuccessDialog(
                          context: context,
                          title: title,
                          description: desc,
                          btnOkOnPress: () {
                            _cargarDatos();
                            context.pop();
                          },
                        );
                      }

                    } catch (e) {
                      debugPrint('Error al registrar pago de cliente: $e');
                      if (!context.mounted) return;
                      final (title, desc) = DialogMessages.clientes.noSePudoRegistrarPago;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          cliente?.nombres ?? "---",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.background,
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
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),

                    Text('DNI: ${cliente?.dni ?? '---'}'),
                    Text('Email: ${cliente?.email ?? '---'}'),
                    Text('Teléfono: ${cliente?.telefono ?? '---'}'),
                    const SizedBox(height: 4),
                    Text(
                      "${cliente?.esDeudor == true ? "DEUDOR" : "REGULAR"}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: cliente?.esDeudor == true
                            ? AppColors.primary
                            : AppColors.success,
                      ),
                    ),
                    Text('Ventas registradas: ${ventasCliente.length}'),
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
                              color: AppColors.primary,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
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
                                          color: AppColors.primary,
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
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Estado: ${venta.estado.name}",
                                        style: TextStyle(
                                          color: venta.estado.name == 'PENDIENTE'
                                              ? Colors.orange.shade800
                                              : AppColors.success,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                ElevatedButton(
                  style: ButtonStyles.success(),
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



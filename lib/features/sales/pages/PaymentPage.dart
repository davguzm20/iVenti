import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/clients/controllers/ClienteController.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> detallesVenta;

  const PaymentPage({super.key, required this.detallesVenta});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool esAlContado = true;
  bool crearCliente = true;

  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<ClienteEntity> clientesFiltrados = [];
  ClienteEntity? clienteSeleccionado;
  double cantidadRecibida = 0.0;

  VentaController get _ventaController => ServiceLocator.ventaController;
  ClienteController get _clienteController =>
      ServiceLocator.clienteController;

  double _calcularTotalVenta() =>
      widget.detallesVenta.fold(0.0, (total, d) => total + (d['subtotalProducto'] as double));

  void _buscarClientesPorNombre(String nombre) async {
    if (nombre.isEmpty) {
      setState(() => clientesFiltrados = []);
      return;
    }

    final clientes = await _clienteController.buscarPorNombre(nombre);

    setState(() => clientesFiltrados = clientes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pago",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 40, top: 12, right: 40, bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cliente:",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.primary),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _buildToggleButton(
                      "Crear Cliente",
                      crearCliente,
                      () => setState(() {
                        crearCliente = true;
                        _searchController.clear();
                        clientesFiltrados.clear();
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: _buildToggleButton(
                      "Buscar Cliente",
                      !crearCliente,
                      () => setState(() => crearCliente = false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (crearCliente) ...[
                CustomTextField(
                  label: "Nombre",
                  controller: _nombreController,
                  keyboardType: TextInputType.text,
                  isRequired: true,
                ),
                CustomTextField(
                  label: "DNI",
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                ),
                CustomTextField(
                  label: "Correo Electrónico",
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ] else ...[
                SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Buscar cliente...",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => clientesFiltrados = []);
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                const BorderSide(color: AppColors.primary),
                          ),
                        ),
                        onChanged: (value) => _buscarClientesPorNombre(value),
                      ),

                      const SizedBox(height: 10),

                      Expanded(
                        child: clientesFiltrados.isEmpty
                            ? const Center(
                                child: Text("No hay clientes encontrados"))
                            : ListView.builder(
                                itemCount: clientesFiltrados.length,
                                itemBuilder: (context, index) {
                                  final c = clientesFiltrados[index];

                                  return ListTile(
                                    title: Text(
                                        '${c.nombres} ${c.apellidos}'),
                                    subtitle:
                                        Text("DNI: ${c.dni ?? '-------'}"),
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        _searchController.text =
                                            '${c.nombres} ${c.apellidos}';
                                        clienteSeleccionado = c;
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Cliente: ${clienteSeleccionado != null ? '${clienteSeleccionado!.nombres} ${clienteSeleccionado!.apellidos}' : "---"}",
                ),
              ],

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _buildToggleButton(
                      "Al contado",
                      esAlContado,
                      () => setState(() => esAlContado = true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: _buildToggleButton(
                      "Crédito",
                      !esAlContado,
                      () => setState(() => esAlContado = false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                "Monto total: ${_calcularTotalVenta().toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildToggleButton(
      String text, bool isSelected, VoidCallback onPressed) {
    return OutlinedButton(
      style: ButtonStyles.outlinedToggle(isSelected),
      onPressed: onPressed,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildTipoPago() {
    final vuelto = cantidadRecibida - _calcularTotalVenta();
    final diferencia = _calcularTotalVenta() - cantidadRecibida;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: "Cantidad recibida",
          controller: _cantidadController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          isPrice: true,
          onChanged: (value) =>
              setState(() => cantidadRecibida = (double.tryParse(value) ?? 0.0)),
        ),

        const SizedBox(height: 8),

        Text(
          esAlContado
              ? (cantidadRecibida == 0.0
                  ? 'Vuelto: ---'
                  : vuelto < 0
                      ? 'Vuelto: Monto Insuficiente'
                      : 'Vuelto: S/${vuelto.toStringAsFixed(2)}')
              : 'Por cancelar: S/${diferencia.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyles.success(),
            onPressed: () async {
              FocusScope.of(context).unfocus();

              if (esAlContado &&
                  cantidadRecibida < _calcularTotalVenta()) {
                final (title, desc) = DialogMessages.ventas.montoInsuficiente;
                ErrorDialog(
                  context: context,
                  title: title,
                  description: desc,
                );
                return;
              }

              if (!esAlContado &&
                  !crearCliente &&
                  clienteSeleccionado == null) {
                final (title, desc) = DialogMessages.ventas.clienteRequerido;
                ErrorDialog(
                  context: context,
                  title: title,
                  description: desc,
                );
                return;
              }

              int? idCliente;

              if (crearCliente) {
                if (_nombreController.text.isEmpty) {
                  final (title, desc) = DialogMessages.ventas.camposIncompletos;
                  ErrorDialog(
                    context: context,
                    title: title,
                    description: desc,
                  );
                  return;
                }

                try {
                  final nuevo = await _clienteController.crearCliente(
                    CrearClienteRequest(
                      nombres: _nombreController.text,
                      apellidos: '',
                      dni: _dniController.text,
                      email: _correoController.text,
                    ),
                  );

                  idCliente = nuevo.idCliente;

                } catch (e) {
                  final (title, desc) = DialogMessages.ventas.noSePudoRegistrarCliente;
                  ErrorDialog(
                    context: context,
                    title: title,
                    description: desc,
                  );
                  return;
                }

              } else {
                idCliente = clienteSeleccionado?.idCliente;
              }

              if (idCliente == null) {
                final (title, desc) = DialogMessages.ventas.clienteNoEncontrado;
                ErrorDialog(
                  context: context,
                  title: title,
                  description: desc,
                );
                return;
              }

              try {
                await _ventaController.crearVenta(
                  CrearVentaRequest(
                    idCliente: idCliente,
                    idUsuario: 1,
                    montoTotal: _calcularTotalVenta(),
                    montoCancelado:
                        esAlContado ? _calcularTotalVenta() : cantidadRecibida,
                    esCredito: !esAlContado,
                    detalles: widget.detallesVenta.map(
                      (d) => DetalleVentaRequest(
                        idProducto: d['idProducto'] as int,
                        idLote: d['idLote'] as int,
                        cantidad: d['cantidadProducto'] as int,
                        precioUnitario: d['precioUnidadProducto'] as double,
                        subtotal: d['subtotalProducto'] as double,
                        ganancia: d['gananciaProducto'] as double,
                        descuento: d['descuentoProducto'] as double,
                      ),
                    ).toList(),
                  ),
                );

                if (mounted) {
                  final (title, desc) = DialogMessages.ventas.ventaRegistrada;
                  SuccessDialog(
                    context: context,
                    title: title,
                    description: desc,
                    btnOkOnPress: () => context.replace('/sales'),
                  );
                }

              } catch (e) {
                final (title, desc) = DialogMessages.ventas.noSePudoRegistrarVenta;
                ErrorDialog(
                  context: context,
                  title: title,
                  description: desc,
                );
              }
            },
            child: const Text(
              "Confirmar",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

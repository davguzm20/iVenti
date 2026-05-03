import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/controllers/VentaController.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _searchTimer;

  List<VentaEntity> ventas = [];
  bool? esAlContado;
  DateTime? fechaInicio;
  DateTime? fechaFinal;
  bool isSearching = false;
  bool isLoading = false;

  VentaController get _ventaController => context.read<VentaController>();

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  void _cargarVentas({bool reiniciar = false}) async {
    if (isLoading) return;

    if (reiniciar) {
      setState(() => ventas.clear());
    }

    setState(() => isLoading = true);

    final nuevas = await _ventaController.obtenerVentasFiltradas(
      limite: 50,
      offset: 0,
      esAlContado: esAlContado,
      fechaInicio: fechaInicio,
      fechaFinal: fechaFinal,
    );

    if (mounted) {
      setState(() {
        if (reiniciar) {
          ventas = nuevas;

        } else {
          ventas.addAll(nuevas);
        }

        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isSearching ? MediaQuery.of(context).size.width - 32 : 150,
          child: isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Buscar venta...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          isSearching = false;
                        });

                        _cargarVentas(reiniciar: true);
                      },
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                  ),
                  onChanged: (value) {},
                )
              : const Text(
                  "Mis ventas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSearching ? 0 : 48,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => isSearching = true),
            ),
          ),

          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await context.push('/sales/create-sale');
                _cargarVentas(reiniciar: true);
              },
            ),

          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () async {
                final filtro = await context.push<Map<String, dynamic>?>(
                  '/sales/filter-sales',
                  extra: {
                    "esAlContado": esAlContado,
                    "fechaInicio": fechaInicio,
                    "fechaFinal": fechaFinal,
                  },
                );

                if (filtro != null) {
                  setState(() {
                    esAlContado = filtro["esAlContado"] as bool?;
                    fechaInicio = filtro["fechaInicio"] as DateTime?;
                    fechaFinal = filtro["fechaFinal"] as DateTime?;
                  });

                  _cargarVentas(reiniciar: true);
                }
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ventas.isEmpty
                ? const Center(
                    child: Text(
                      "No se encontraron ventas",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: ventas.length,
                    itemBuilder: (context, index) {
                      final venta = ventas[index];
                      final tipoPago = venta.esCredito
                          ? (venta.montoCancelado >= venta.montoTotal
                              ? "Crédito (Cancelado)"
                              : "Crédito")
                          : "Al contado";

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF493D9E), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
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
                                        color: Color(0xFF493D9E),
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      "Fecha: ${venta.creadoEn.toIso8601String().split('T')[0]}",
                                      style: const TextStyle(
                                          color: Colors.black),
                                    ),

                                    Text(
                                      "Monto: S/ ${venta.montoTotal.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.black),
                                    ),

                                    Text(
                                      "Tipo de pago: $tipoPago",
                                      style: TextStyle(
                                        color: venta.esCredito &&
                                                venta.montoCancelado <
                                                    venta.montoTotal
                                            ? Colors.red
                                            : venta.esCredito
                                                ? const Color(0xFF2BBF55)
                                                : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2BBF55),
                                      foregroundColor: Colors.white,
                                      elevation: 6,
                                      shadowColor:
                                          Colors.black.withOpacity(0.3),
                                    ),
                                    onPressed: () {
                                      context.push(
                                          '/sales/details-sale/${venta.idVenta}');

                                      _cargarVentas(reiniciar: true);
                                    },
                                    child: const Text("Detalles"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 6,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

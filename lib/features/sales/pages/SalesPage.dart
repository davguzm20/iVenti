import 'dart:async';
import 'package:iventi/shared/di/ServiceLocator.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/features/sales/controllers/VentaController.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/widgets/SaleCard.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';

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
  int cantidadCargas = 0;
  bool hayMasCargas = true;
  bool isSearching = false;
  bool isLoading = false;

  VentaController get _ventaController => ServiceLocator.ventaController;

  @override
  void initState() {
    super.initState();
    _cargarVentas();
    _scrollController.addListener(_detectarScrollFinal);
  }

  void _detectarScrollFinal() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        hayMasCargas) {
      _cargarVentas();
    }
  }

  void _cargarVentas({bool reiniciar = false}) async {
    if (!hayMasCargas && !reiniciar) return;
    if (isLoading) return;

    if (reiniciar) {
      setState(() { ventas.clear(); cantidadCargas = 0; hayMasCargas = true; });
    }

    setState(() => isLoading = true);

    try {
      final nuevas = await _ventaController.obtenerVentasFiltradas(
        limite: 50,
        offset: cantidadCargas * 50,
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
          if (nuevas.isNotEmpty) {
            cantidadCargas++;
          } else {
            hayMasCargas = false;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ErrorDialog(context: context, title: 'Error', description: 'No se pudieron cargar las ventas');
      }
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
        title: isSearching
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
                      setState(() { isSearching = false; });
                      _cargarVentas(reiniciar: true);
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.2),
                ),
                onChanged: (value) {
                  _searchTimer?.cancel();
                  _searchTimer = Timer(const Duration(milliseconds: 300), () {
                    if (value.isEmpty) {
                      _cargarVentas(reiniciar: true);
                      return;
                    }
                    setState(() {
                      ventas = ventas.where((v) =>
                        '${v.idVenta}'.contains(value) ||
                        v.montoTotal.toString().contains(value) ||
                        (v.esCredito ? 'credito' : 'contado').contains(value.toLowerCase())
                      ).toList();
                    });
                  });
                },
              )
            : const FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
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

                      return SaleCard(
                        venta: venta,
                        onTap: () {
                          context.push('/sales/details-sale/${venta.idVenta}');
                          _cargarVentas(reiniciar: true);
                        },
                        onDetails: () {
                          context.push('/sales/details-sale/${venta.idVenta}');
                          _cargarVentas(reiniciar: true);
                        },
                      );
                    },
                  ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
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



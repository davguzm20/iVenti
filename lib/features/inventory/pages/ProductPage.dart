import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/LoteController.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';

class ProductPage extends StatefulWidget {
  final int idProducto;

  const ProductPage({super.key, required this.idProducto});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductoEntity? producto;
  List<LoteEntity> lotesProducto = [];
  List<CategoriaEntity> categoriasProducto = [];
  UnidadEntity? unidadProducto;

  ProductoController get _productoController =>
      context.read<ProductoController>();
  LoteController get _loteController => context.read<LoteController>();
  CategoriaController get _categoriaController =>
      context.read<CategoriaController>();
  UnidadController get _unidadController =>
      context.read<UnidadController>();

  @override
  void initState() {
    super.initState();

    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final p = await _productoController.obtenerProductoPorId(widget.idProducto);

    if (p == null) {
      ErrorDialog(context: context, errorMessage: "Producto no encontrado.");
      return;
    }

    if (mounted) {
      final cats = await _categoriaController.obtenerDeProducto(widget.idProducto);
      final unis = await _unidadController.obtenerTodas();
      final lotes = await _loteController.obtenerLotesDeProducto(widget.idProducto);
      final u = unis.where((x) => x.idUnidad == p.idUnidad).firstOrNull;

      setState(() {
        producto = p;
        categoriasProducto = cats;
        unidadProducto = u;
        lotesProducto = lotes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          producto?.nombre ?? "Cargando...",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: producto == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: ListView(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: screenWidth * 0.2,
                        width: screenWidth * 0.2,
                        child: const Image(
                          image: AssetImage('lib/assets/iconos/iconoImagen.png'),
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Código del producto",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),

                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                producto!.codigo ?? "-" * 13,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

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
                            "Stock actual: ${producto!.stockActual} ${unidadProducto?.abreviatura ?? ''}",
                            style: const TextStyle(
                              color: Color(0xFF493d9e),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            "Stock mínimo: ${producto!.stockMinimo} ${unidadProducto?.abreviatura ?? ''}",
                            style: const TextStyle(
                              color: Color(0xFF493d9e),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const Divider(),

                          Text(
                            "Unidad: ${unidadProducto?.nombre ?? 'No definida'}",
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ),

                          Text(
                            "Precio: S/ ${producto!.precio.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildCategoriasSection(),

                  const SizedBox(height: 20),

                  const Text(
                    "Lotes del producto",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (lotesProducto.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Aún no hay lotes creados para este producto.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    ...lotesProducto.map(
                      (lote) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF493d9e),
                            foregroundColor: Colors.white,
                            child: Text('${lote.idLote}'),
                          ),
                          title: Text(
                            "Cantidad Actual: ${lote.cantidadActual} ${unidadProducto?.abreviatura ?? ''}",
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Comprada: ${lote.cantidadComprada} ${unidadProducto?.abreviatura ?? ''}",
                              ),
                              Text("Pérdidas: ${lote.cantidadPerdida}"),
                              Text(
                                "Precio Compra: S/ ${lote.precioCompra.toStringAsFixed(2)}",
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

  Widget _buildCategoriasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categorías',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF493D9E),
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categoriasProducto
              .map(
                (c) => FilterChip(
                  label: Text(c.nombre),
                  selected: true,
                  selectedColor: const Color(0xFF493D9E),
                  backgroundColor: Colors.grey[200],
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  onSelected: null,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

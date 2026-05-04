import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/LoteController.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';

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
      ServiceLocator.productoController;
  LoteController get _loteController => ServiceLocator.loteController;
  CategoriaController get _categoriaController =>
      ServiceLocator.categoriaController;
  UnidadController get _unidadController =>
      ServiceLocator.unidadController;

  @override
  void initState() {
    super.initState();

    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final p = await _productoController.obtenerProductoPorId(widget.idProducto);

    if (p == null) {
      final (title, desc) = DialogMessages.inventario.productoNoEncontrado;
      ErrorDialog(
        context: context,
        title: title,
        description: desc,
      );
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
        backgroundColor: AppColors.background,
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
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          Text(
                            "Stock mínimo: ${producto!.stockMinimo} ${unidadProducto?.abreviatura ?? ''}",
                            style: const TextStyle(
                              color: AppColors.primary,
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
                            backgroundColor: AppColors.primary,
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
            color: AppColors.primary,
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
                  selectedColor: AppColors.primary,
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

import 'package:flutter/material.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';

class FilterProductsPage extends StatefulWidget {
  final Map<String, dynamic>? filtrosIniciales;

  const FilterProductsPage({super.key, this.filtrosIniciales});

  @override
  State<FilterProductsPage> createState() => _FilterProductsPageState();
}

class _FilterProductsPageState extends State<FilterProductsPage> {
  List<CategoriaEntity> categoriasObtenidas = [];
  List<int> categoriasSeleccionadas = [];
  bool? stockBajo;
  bool habilitarStock = false;
  bool habilitarCategorias = false;

  @override
  void initState() {
    super.initState();
    final iniciales = widget.filtrosIniciales;
    if (iniciales != null) {
      final ids = iniciales['idCategorias'] as List<int>? ?? [];
      categoriasSeleccionadas = List.from(ids);
      stockBajo = iniciales['stockBajo'] as bool?;
      habilitarStock = stockBajo != null;
      habilitarCategorias = ids.isNotEmpty;
    }
    _obtenerCategorias();
  }

  Future<void> _obtenerCategorias() async {
    try {
      final cats = await ServiceLocator.categoriaController.obtenerTodas();
      setState(() => categoriasObtenidas = cats);
    } catch (e) {
      debugPrint('Error al obtener categorías: $e');
    }
  }

  void _aplicarFiltros() {
    context.pop({
      'idCategorias': habilitarCategorias ? categoriasSeleccionadas : <int>[],
      'stockBajo': habilitarStock ? stockBajo : null,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filtrar productos")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text(
                              "Filtrar por Categorías",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              "Activa esta opción para seleccionar categorías específicas.",
                              style: TextStyle(color: Colors.black54),
                            ),
                            value: habilitarCategorias,
                            activeThumbColor: AppColors.success,
                            onChanged: (value) {
                              setState(() {
                                habilitarCategorias = value;
                                if (!value) categoriasSeleccionadas.clear();
                              });
                            },
                          ),
                          if (habilitarCategorias)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: categoriasObtenidas.map((cat) {
                                final sel = categoriasSeleccionadas.contains(cat.idCategoria);
                                return FilterChip(
                                  label: Text(cat.nombre),
                                  selected: sel,
                                  selectedColor: AppColors.primary,
                                  backgroundColor: Colors.grey[200],
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: sel ? Colors.white : AppColors.primary,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        categoriasSeleccionadas.add(cat.idCategoria!);
                                      } else {
                                        categoriasSeleccionadas.remove(cat.idCategoria);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SwitchListTile(
                            title: const Text(
                              "Filtrar por Stock",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              "Activa esta opción para elegir si mostrar productos con stock bajo o normal.",
                              style: TextStyle(color: Colors.black54),
                            ),
                            value: habilitarStock,
                            activeThumbColor: AppColors.success,
                            onChanged: (value) {
                              setState(() {
                                habilitarStock = value;
                                stockBajo = value ? true : null;
                              });
                            },
                          ),
                          if (habilitarStock)
                            Column(
                              children: [
                                const Text(
                                  "¿Qué productos quieres ver?",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => setState(() => stockBajo = true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: stockBajo == true ? Colors.red : Colors.grey[300],
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                      child: Text(
                                        "Stock Bajo",
                                        style: TextStyle(
                                          color: stockBajo == true ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () => setState(() => stockBajo = false),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: stockBajo == false ? AppColors.success : Colors.grey[300],
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                      child: Text(
                                        "Stock Normal",
                                        style: TextStyle(
                                          color: stockBajo == false ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: AppColors.primary,
                ),
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                label: const Text("Aplicar Filtros", style: TextStyle(fontSize: 18, color: Colors.white)),
                onPressed: _aplicarFiltros,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



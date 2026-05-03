import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  Timer? _searchTimer;

  List<ProductoEntity> productos = [];

  bool? stockBajo;
  String nombreProductoBuscado = "";
  bool isSearching = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _cargarProductos();
  }

  ProductoController get _productoController =>
      context.read<ProductoController>();

  Future<void> _cargarProductos({bool reiniciar = false}) async {
    if (isLoading) return;

    if (reiniciar) {
      setState(() {
        productos.clear();
      });
    }

    setState(() {
      isLoading = true;
    });

    final nuevos = await _productoController.obtenerTodos();

    if (mounted) {
      setState(() {
        if (reiniciar) {
          productos = nuevos;

        } else {
          productos.addAll(nuevos);
        }

        isLoading = false;
      });
    }
  }

  void _buscarProductosPorNombre(String nombre) {
    if (_searchTimer?.isActive ?? false) {
      _searchTimer!.cancel();
    }

    _searchTimer = Timer(const Duration(milliseconds: 300), () async {
      if (nombre.isEmpty) {
        _cargarProductos(reiniciar: true);
        return;
      }

      final productosFiltrados =
          await _productoController.buscarPorNombre(nombre);

      setState(() {
        productos = productosFiltrados;
      });
    });
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
                    hintText: "Buscar producto...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          isSearching = false;
                          nombreProductoBuscado = "";
                        });

                        _cargarProductos(reiniciar: true);
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
                  onChanged: (value) {
                    setState(() {
                      nombreProductoBuscado = value;
                    });

                    _buscarProductosPorNombre(value);
                  },
                )
              : const Text(
                  "Mis productos",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
        actions: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSearching ? 0 : 48,
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
          ),

          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await context.push('/inventory/create-product');
                _cargarProductos(reiniciar: true);
              },
            ),

          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () async {
                final filtros = await context.push<Map<String, dynamic>>(
                  '/inventory/filter-products',
                  extra: {'stockBajo': stockBajo},
                );

                if (filtros != null) {
                  setState(() {
                    stockBajo = filtros['stockBajo'] as bool?;
                  });
                }

                _cargarProductos(reiniciar: true);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          productos.isEmpty
              ? const Center(
                  child: Text(
                    "No se encontraron productos",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    final bool esStockBajo =
                        producto.stockActual < producto.stockMinimo;

                    return GestureDetector(
                      onTap: () async {
                        await context.push(
                            '/inventory/product/${producto.idProducto}');

                        _cargarProductos(reiniciar: true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                          border: Border.all(
                            color: const Color(0xFF493D9E),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 90,
                              height: 90,
                              child: Image(
                                image: AssetImage(
                                    'lib/assets/iconos/iconoImagen.png'),
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              producto.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF493D9E),
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "S/. ${producto.precio.toStringAsFixed(2)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: esStockBajo
                                    ? Colors.red.withOpacity(0.15)
                                    : const Color(0xFF2BBF55)
                                        .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "Stock: ${producto.stockActual}",
                                style: TextStyle(
                                  color: esStockBajo
                                      ? Colors.red
                                      : const Color(0xFF2BBF55),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 6,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

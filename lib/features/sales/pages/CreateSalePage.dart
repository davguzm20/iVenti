import 'package:flutter/material.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:go_router/go_router.dart';

import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/features/sales/widgets/CartWidget.dart';

class CreateSalePage extends StatefulWidget {
  const CreateSalePage({super.key});

  @override
  State<CreateSalePage> createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  List<Map<String, dynamic>> productosVenta = [];

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _AddProductDialog(
        onProductAdded: (producto) {
          setState(() => productosVenta.add(producto));
        },
      ),
    );
  }

  double _calcularTotalVenta() => productosVenta.fold(0.0, (total, p) => total + (p['subtotalProducto'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Venta")),
      body: CartWidget(
        items: productosVenta,
        total: _calcularTotalVenta(),
        onDeleteItem: (index) => setState(() => productosVenta.removeAt(index)),
        onConfirm: () async {
          if (productosVenta.isEmpty) {
            final (title, desc) = DialogMessages.ventas.sinProductos;
            ErrorDialog(
              context: context,
              title: title,
              description: desc,
            );
            return;
          }
          await context.push('/sales/create-sale/payment', extra: productosVenta);
        },
        onAddProduct: _showAddProductDialog,
      ),
    );
  }
}

class _AddProductDialog extends StatefulWidget {
  final void Function(Map<String, dynamic> producto) onProductAdded;
  const _AddProductDialog({required this.onProductAdded});

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductoEntity> productosFiltrados = [];
  List<ProductoEntity> productosRecientes = [];
  LoteEntity? loteSeleccionado;
  ProductoEntity? productoSeleccionado;
  int cantidadValue = 1;
  double descuentoValue = 0;
  List<LoteEntity> lotesDisponibles = [];

  @override
  void initState() {
    super.initState();
    _cargarRecientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarRecientes() async {
    try {
      final r = await ServiceLocator.productoController.obtenerProductosRecientes(3);
      if (mounted) setState(() => productosRecientes = r);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Agregar producto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _handleScanner,
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: (productosFiltrados.isNotEmpty
                        ? productosFiltrados
                        : productosRecientes)
                    .map((p) {
                  return ListTile(
                    dense: true,
                    title: Text(p.nombre),
                    subtitle: Text('S/ ${p.precio.toStringAsFixed(2)}'),
                    onTap: () => _onProductSelected(p),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            if (loteSeleccionado != null && lotesDisponibles.isNotEmpty) ...[
              DropdownButtonFormField<int>(
                initialValue: loteSeleccionado!.idLote,
                items: lotesDisponibles.map((l) => DropdownMenuItem(
                  value: l.idLote,
                  child: Text('Lote ${l.idLote} - Stock: ${l.cantidadActual}'),
                )).toList(),
                onChanged: (idLote) {
                  setState(() {
                    loteSeleccionado = lotesDisponibles.firstWhere((l) => l.idLote == idLote);
                  });
                },
                decoration: const InputDecoration(labelText: 'Lote', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: cantidadValue > 1 ? () => setState(() => cantidadValue--) : null,
                  ),
                  Text(cantidadValue.toString(), style: const TextStyle(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: cantidadValue < (loteSeleccionado?.cantidadActual ?? 0)
                        ? () => setState(() => cantidadValue++)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Subtotal: S/ ${(loteSeleccionado!.precioCompra * cantidadValue - descuentoValue).toStringAsFixed(2)}'),
            ] else if (productoSeleccionado != null) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Producto sin stock disponible', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
              ),
            ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        TextButton(
          onPressed: () {
            if (productoSeleccionado != null && loteSeleccionado != null) {
              widget.onProductAdded({
                'idProducto': productoSeleccionado!.idProducto,
                'idLote': loteSeleccionado!.idLote,
                'nombre': productoSeleccionado!.nombre,
                'precio': productoSeleccionado!.precio,
                'cantidad': cantidadValue,
                'subtotalProducto': productoSeleccionado!.precio * cantidadValue - descuentoValue,
                'precioUnidadProducto': productoSeleccionado!.precio,
                'descuentoProducto': descuentoValue,
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Agregar'),
        ),
      ],
    );
  }

  Future<void> _onSearchChanged(String v) async {
    if (v.length < 2) {
      setState(() => productosFiltrados = []);
      return;
    }
    try {
      final r = await ServiceLocator.productoController.buscarPorNombre(v);
      if (mounted) setState(() => productosFiltrados = r);
    } catch (_) {}
  }

  Future<void> _onProductSelected(ProductoEntity p) async {
    FocusScope.of(context).unfocus();
    productoSeleccionado = p;
    loteSeleccionado = null;
    lotesDisponibles = [];
    setState(() {});
    try {
      final lotes = await ServiceLocator.loteController.obtenerLotesDeProducto(p.idProducto!);
      if (mounted) {
        setState(() {
          lotesDisponibles = lotes;
          loteSeleccionado = lotes.isNotEmpty ? lotes.first : null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {});
        final (title, desc) = DialogMessages.error.inesperado;
        ErrorDialog(context: context, title: title, description: '$desc\n$e');
      }
    }
  }

  Future<void> _handleScanner() async {
    try {
      final code = await context.push('/barcode-scanner');
      if (code == null || !mounted) return;
      final p = await ServiceLocator.productoController.obtenerProductoPorCodigo(code.toString());
      if (p == null) {
        if (mounted) {
          final (title, desc) = DialogMessages.inventario.productoNoEncontrado;
          ErrorDialog(context: context, title: title, description: desc);
        }
        return;
      }
      if (!mounted) return;
      final lotes = await ServiceLocator.loteController.obtenerLotesDeProducto(p.idProducto!);
      if (mounted) {
        setState(() {
          productoSeleccionado = p;
          lotesDisponibles = lotes;
          loteSeleccionado = lotes.isNotEmpty ? lotes.first : null;
        });
      }
    } catch (e) {
      if (mounted) {
        final (title, desc) = DialogMessages.error.inesperado;
        ErrorDialog(context: context, title: title, description: '$desc\n$e');
      }
    }
  }
}


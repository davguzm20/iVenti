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
  List<ProductoEntity> productosFiltrados = [];

  void _showAddProductDialog() {
    LoteEntity? loteSeleccionado;
    ProductoEntity? productoSeleccionado;
    int cantidadValue = 1;
    double descuentoValue = 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          List<ProductoEntity> productosRecientes = [];

          Future.microtask(() async {
            final r = await ServiceLocator.productoController.obtenerProductosRecientes(3);
            if (ctx.mounted) setDialogState(() => productosRecientes = r);
          });

          return AlertDialog(
            scrollable: true,
            title: const Text('Agregar producto'),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar producto...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) async {
                      if (v.isEmpty) {
                        setDialogState(() => productosFiltrados = []);
                      } else {
                        final r = await ServiceLocator.productoController.buscarPorNombre(v);
                        if (!ctx.mounted) return;
                        setDialogState(() => productosFiltrados = r);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      children: (productosFiltrados.isNotEmpty
                              ? productosFiltrados
                              : productosRecientes)
                          .map((p) {
                        return ListTile(
                          dense: true,
                          title: Text(p.nombre),
                          subtitle: Text('S/ ${p.precio.toStringAsFixed(2)}'),
                          onTap: () async {
                            FocusScope.of(ctx).unfocus();
                            final lotes = await ServiceLocator.loteController.obtenerLotesDeProducto(p.idProducto!);
                            setDialogState(() {
                              productoSeleccionado = p;
                              loteSeleccionado = lotes.isNotEmpty ? lotes.first : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(),
                  if (loteSeleccionado != null) ...[
                    DropdownButtonFormField<int>(
                      initialValue: loteSeleccionado!.idLote,
                      items: [loteSeleccionado!].map((l) => DropdownMenuItem(value: l.idLote, child: Text('Lote ${l.idLote} - Stock: ${l.cantidadActual}'))).toList(),
                      onChanged: null,
                      decoration: const InputDecoration(labelText: 'Lote', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: const Icon(Icons.remove), onPressed: cantidadValue > 1 ? () => setDialogState(() => cantidadValue--) : null),
                        Text(cantidadValue.toString(), style: const TextStyle(fontSize: 18)),
                        IconButton(icon: const Icon(Icons.add), onPressed: cantidadValue < (loteSeleccionado?.cantidadActual ?? 0) ? () => setDialogState(() => cantidadValue++) : null),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Subtotal: S/ ${(loteSeleccionado!.precioCompra * cantidadValue - descuentoValue).toStringAsFixed(2)}'),
                  ],
                ],
              ),
            actions: [
              TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
              TextButton(
                onPressed: () {
                  if (productoSeleccionado != null && loteSeleccionado != null) {
                    final p = productoSeleccionado!;
                    setState(() {
                      productosVenta.add({
                        'idProducto': p.idProducto,
                        'idLote': loteSeleccionado!.idLote,
                        'nombre': p.nombre,
                        'precio': p.precio,
                        'cantidad': cantidadValue,
                        'subtotalProducto': p.precio * cantidadValue - descuentoValue,
                        'precioUnidadProducto': p.precio,
                        'descuentoProducto': descuentoValue,
                      });
                    });
                    context.pop();
                  }
                },
                child: const Text('Agregar'),
              ),
            ],
          );
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



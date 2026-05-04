import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/theme/ButtonStyles.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';

class CreateSalePage extends StatefulWidget {
  const CreateSalePage({super.key});

  @override
  State<CreateSalePage> createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  List<Map<String, dynamic>> productosVenta = [];
  List<ProductoEntity> productosFiltrados = [];
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  void _buscarProductosPorNombre(String nombre) async {
    if (nombre.isEmpty) { setState(() => productosFiltrados = []); return; }
    final results = await ServiceLocator.productoController.buscarPorNombre(nombre);
    if (mounted) setState(() => productosFiltrados = results);
  }

  void _showAddProductDialog() {
    LoteEntity? loteSeleccionado;
    int cantidadValue = 1;
    double descuentoValue = 0;
    String busqueda = '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('Agregar producto'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar producto...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) async {
                      busqueda = v;
                      if (v.isEmpty) {
                        setDialogState(() => productosFiltrados = []);
                      } else {
                        final r = await ServiceLocator.productoController.buscarPorNombre(v);
                        setDialogState(() => productosFiltrados = r);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      children: productosFiltrados.map((p) {
                        return ListTile(
                          dense: true,
                          title: Text(p.nombre),
                          subtitle: Text('S/ ${p.precio.toStringAsFixed(2)}'),
                          onTap: () async {
                            final lotes = await ServiceLocator.loteController.obtenerLotesDeProducto(p.idProducto!);
                            setDialogState(() {
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
                      value: loteSeleccionado!.idLote,
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
            ),
            actions: [
              TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
              TextButton(
                onPressed: () {
                  if (productosFiltrados.isNotEmpty && loteSeleccionado != null) {
                    final p = productosFiltrados.first;
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
                        'gananciaProducto': (p.precio * cantidadValue - descuentoValue) - (loteSeleccionado!.precioCompra * cantidadValue),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Agregar producto', style: TextStyle(color: Colors.white)),
              style: ButtonStyles.success(),
              onPressed: _showAddProductDialog,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
              child: productosVenta.isEmpty
                  ? const Center(child: Text("No hay productos agregados"))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: productosVenta.length,
                      itemBuilder: (context, index) => Slidable(
                        key: ValueKey(productosVenta[index]['id']),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => setState(() => productosVenta.removeAt(index)),
                              backgroundColor: AppColors.danger, foregroundColor: Colors.white,
                              icon: Icons.delete, label: 'Eliminar',
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 50, height: 50, child: Image(image: AssetImage('lib/assets/iconos/iconoImagen.png'), fit: BoxFit.cover)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(productosVenta[index]['nombre'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Precio: S/ ${productosVenta[index]['precio']}"),
                                    Text("Cantidad: ${productosVenta[index]['cantidad']}"),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text("Subtotal", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("S/ ${(productosVenta[index]['subtotal'] as double).toStringAsFixed(2)}"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    Container(
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(_calcularTotalVenta().toStringAsFixed(2), style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
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
                  style: ButtonStyles.success(borderRadius: 30).copyWith(
                    padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                  ),
                  child: const Text("Confirmar", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

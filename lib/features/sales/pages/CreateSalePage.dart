import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';

class CreateSalePage extends StatefulWidget {
  const CreateSalePage({super.key});

  @override
  State<CreateSalePage> createState() => _CreateSalePageState();
}

class _CreateSalePageState extends State<CreateSalePage> {
  List<Map<String, dynamic>> productosVenta = [];
  List<Map<String, dynamic>> productosFiltrados = [];

  void _buscarProductosPorNombre(String nombre) async {
    if (nombre.isEmpty) { setState(() => productosFiltrados = []); return; }
    // NOTE: search products via controller when integrated
    setState(() => productosFiltrados = []);
  }

  double _calcularTotalVenta() => productosVenta.fold(0.0, (total, p) => total + (p['subtotal'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Venta")),
      body: Column(
        children: [
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
                              backgroundColor: Colors.red, foregroundColor: Colors.white,
                              icon: Icons.delete, label: 'Eliminar',
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color.fromARGB(255, 124, 33, 243), width: 2),
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
                    const Text("Total: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 124, 33, 243))),
                    Container(
                      decoration: BoxDecoration(color: const Color.fromARGB(255, 124, 33, 243), borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(_calcularTotalVenta().toStringAsFixed(2), style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (productosVenta.isEmpty) {
                      ErrorDialog(context: context, errorMessage: "No se ha seleccionado ningun producto");
                      return;
                    }
                    await context.push('/sales/create-sale/payment', extra: productosVenta);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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

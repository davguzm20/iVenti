import 'dart:io';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/LoteController.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/ConfirmDialog.dart';
import 'package:iventi/shared/theme/AppColors.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';

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
  bool editandoCategorias = false;

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
      if (!mounted) return;
      final (t, d) = DialogMessages.inventario.productoNoEncontrado;
      ErrorDialog(context: context, title: t, description: d);
      return;
    }
    if (mounted) {
      final cats = await _categoriaController.obtenerDeProducto(widget.idProducto);
      final unis = await _unidadController.obtenerTodas();
      final lotes = await _loteController.obtenerLotesDeProducto(widget.idProducto);
      final u = unis.where((x) => x.idUnidad == p.idUnidad).firstOrNull;
      setState(() { producto = p; categoriasProducto = cats; unidadProducto = u; lotesProducto = lotes; });
    }
  }

  Future<void> _recargarLotes() async {
    final lotes = await _loteController.obtenerLotesDeProducto(widget.idProducto);
    if (mounted) setState(() => lotesProducto = lotes);
  }

  Future<void> _recargarCategorias() async {
    final cats = await _categoriaController.obtenerDeProducto(widget.idProducto);
    if (mounted) setState(() => categoriasProducto = cats);
  }

  void _showEditProductDialog() {
    final codigoCtrl = TextEditingController(text: producto?.codigo ?? '');
    final nombreCtrl = TextEditingController(text: producto?.nombre ?? '');
    final precioCtrl = TextEditingController(text: producto?.precio.toStringAsFixed(2) ?? '');
    final stockMinCtrl = TextEditingController(text: producto?.stockMinimo.toString() ?? '');
    String? nuevaRuta = producto?.rutaImagen;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Producto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final r = await context.push('/image-picker');
                  if (r != null) nuevaRuta = r as String;
                },
                child: SizedBox(
                  width: 80, height: 80,
                  child: nuevaRuta == null
                      ? Image.asset('lib/assets/iconos/iconoImagen.png', fit: BoxFit.cover)
                      : Image.file(File(nuevaRuta!), fit: BoxFit.cover),
                ),
              ),
              TextField(controller: codigoCtrl, decoration: const InputDecoration(labelText: 'Código')),
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre *')),
              TextField(controller: precioCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio *')),
              TextField(controller: stockMinCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock mínimo')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (nombreCtrl.text.trim().isEmpty) return;
              await _productoController.actualizarProducto(
                ActualizarProductoRequest(
                  idProducto: widget.idProducto,
                  idUnidad: producto!.idUnidad,
                  codigo: codigoCtrl.text.isNotEmpty ? codigoCtrl.text : null,
                  nombre: nombreCtrl.text,
                  precio: double.tryParse(precioCtrl.text) ?? producto!.precio,
                  stockMinimo: int.tryParse(stockMinCtrl.text) ?? producto!.stockMinimo,
                  rutaImagen: nuevaRuta,
                ),
              );
              if (!mounted) return;
              context.pop();
              _cargarDatos();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarProducto() async {
    ConfirmDialog(
      context: context,
      title: 'Eliminar producto',
      message: '¿Estás seguro de eliminar este producto?',
      btnOkOnPress: () async {
        await _productoController.eliminarProducto(widget.idProducto);
        if (mounted) context.pop();
      },
    );
  }

  void _showAddLoteDialog() {
    final cantCompradaCtrl = TextEditingController();
    final cantPerdidaCtrl = TextEditingController(text: '0');
    final precioCompraCtrl = TextEditingController();
    DateTime? fechaCompra = DateTime.now();
    DateTime? fechaVenc = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Agregar lote'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: cantCompradaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cantidad comprada *')),
              TextField(controller: cantPerdidaCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Cantidad perdida')),
              TextField(controller: precioCompraCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio compra *')),
              const SizedBox(height: 10),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text('Compra: ${fechaCompra!.toLocal().toString().split(' ')[0]}'),
                onPressed: () async {
                  final d = await showDatePicker(context: ctx, initialDate: fechaCompra!, firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (d != null) { fechaCompra = d; (context as Element).markNeedsBuild(); }
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text('Vence: ${fechaVenc!.toLocal().toString().split(' ')[0]}'),
                onPressed: () async {
                  final d = await showDatePicker(context: ctx, initialDate: fechaVenc!, firstDate: DateTime.now(), lastDate: DateTime(2030));
                  if (d != null) { fechaVenc = d; (context as Element).markNeedsBuild(); }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final cc = int.tryParse(cantCompradaCtrl.text) ?? 0;
              if (cc <= 0) return;
              await _loteController.crearLote(
                CrearLoteRequest(
                  idProducto: widget.idProducto,
                  fechaCompra: fechaCompra!,
                  fechaVencimiento: fechaVenc!,
                  cantidadComprada: cc,
                  cantidadPerdida: int.tryParse(cantPerdidaCtrl.text) ?? 0,
                  precioCompra: double.tryParse(precioCompraCtrl.text) ?? 0,
                ),
              );
              if (!mounted) return;
              context.pop();
              _recargarLotes();
              _cargarDatos();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showEditLoteDialog(LoteEntity lote) async {
    _recargarLotes();
    _cargarDatos();
  }

  Future<void> _eliminarLote(LoteEntity lote) async {
    ConfirmDialog(
      context: context,
      title: 'Eliminar lote',
      message: '¿Estás seguro de eliminar el lote ${lote.idLote}?',
      btnOkOnPress: () async {
        if (lote.idLote != null) {
          await _loteController.eliminarLote(lote.idProducto, lote.idLote!);
          _recargarLotes();
          _cargarDatos();
        }
      },
    );
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
        actions: [
          if (producto != null) ...[
            IconButton(icon: const Icon(Icons.edit, color: Colors.black), onPressed: _showEditProductDialog),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _eliminarProducto),
          ],
        ],
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: producto!.rutaImagen == null
                              ? const Image(
                                  image: AssetImage('lib/assets/iconos/iconoImagen.png'),
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(producto!.rutaImagen!),
                                  fit: BoxFit.cover,
                                ),
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
                            "Precio: S/ ${producto!.precio.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ),

                          Text(
                            "Unidad: ${unidadProducto?.nombre ?? 'No definida'}",
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildCategoriasSection(),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Lotes del producto",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppColors.primary),
                        onPressed: _showAddLoteDialog,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  if (lotesProducto.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Aún no hay lotes creados para este producto.",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
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
                          title: Text("Cantidad Actual: ${lote.cantidadActual} ${unidadProducto?.abreviatura ?? ''}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Comprada: ${lote.cantidadComprada} ${unidadProducto?.abreviatura ?? ''}"),
                              Text("Pérdidas: ${lote.cantidadPerdida}"),
                              Text("Precio Compra: S/ ${lote.precioCompra.toStringAsFixed(2)}"),
                              Text("Fecha compra: ${lote.fechaCompra.toLocal().toString().split(' ')[0]}"),
                              Text("Vence: ${lote.fechaVencimiento.toLocal().toString().split(' ')[0]}"),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'edit') _showEditLoteDialog(lote);
                              if (v == 'delete') _eliminarLote(lote);
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: 'edit', child: Text('Editar')),
                              const PopupMenuItem(value: 'delete', child: Text('Eliminar', style: TextStyle(color: Colors.red))),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            IconButton(
              icon: Icon(editandoCategorias ? Icons.check : Icons.edit, color: AppColors.primary),
              onPressed: () => setState(() => editandoCategorias = !editandoCategorias),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: categoriasProducto.map((c) => FilterChip(
            label: Text(c.nombre),
            selected: true,
            selectedColor: AppColors.primary,
            backgroundColor: Colors.grey[200],
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            onSelected: editandoCategorias ? (_) => _eliminarCategoriaDeProducto(c) : null,
          )).toList(),
        ),
        if (editandoCategorias) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: _showAgregarCategoriaAProducto,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('+ Agregar categoría'),
          ),
          TextButton(
            onPressed: _showNuevaCategoria,
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('+ Crear nueva categoría'),
          ),
        ],
      ],
    );
  }

  Future<void> _eliminarCategoriaDeProducto(CategoriaEntity cat) async {
    setState(() => editandoCategorias = false);
    await _categoriaController.eliminarDeProducto(producto!.idProducto!, cat.idCategoria!);
    _recargarCategorias();
  }

  void _showAgregarCategoriaAProducto() {
    CategoriaEntity? seleccionada;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Agregar categoría'),
          content: FutureBuilder<List<CategoriaEntity>>(
            future: _categoriaController.obtenerTodas(),
            builder: (ctx, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();
              return DropdownButtonFormField<int>(
                initialValue: seleccionada?.idCategoria,
                items: snap.data!.map((c) => DropdownMenuItem(value: c.idCategoria, child: Text(c.nombre))).toList(),
                onChanged: (v) => setDialogState(() => seleccionada = snap.data!.firstWhere((c) => c.idCategoria == v)),
                decoration: const InputDecoration(labelText: 'Seleccionar categoría', border: OutlineInputBorder()),
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
            TextButton(
              onPressed: () async {
                if (seleccionada != null) {
                  await _categoriaController.asignarAProducto(producto!.idProducto!, seleccionada!.idCategoria!);
                  if (mounted) context.pop();
                  _recargarCategorias();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNuevaCategoria() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva categoría'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                await _categoriaController.crearCategoria(CrearCategoriaRequest(nombre: ctrl.text.trim()));
                if (!mounted) return;
                context.pop();
                _recargarCategorias();
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}



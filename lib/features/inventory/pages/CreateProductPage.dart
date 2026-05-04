import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iventi/shared/widgets/CustomTextField.dart';
import 'package:iventi/shared/di/ServiceLocator.dart';
import 'package:iventi/shared/widgets/ErrorDialog.dart';
import 'package:iventi/shared/widgets/SuccessDialog.dart';
import 'package:iventi/shared/utils/DialogMessages.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/shared/config/AppColors.dart';
import 'package:iventi/shared/config/ButtonStyles.dart';
import 'package:iventi/features/inventory/controllers/ProductoController.dart';
import 'package:iventi/features/inventory/controllers/CategoriaController.dart';
import 'package:iventi/features/inventory/controllers/UnidadController.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController minStockController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  List<CategoriaEntity> categoriasDisponibles = [];
  List<UnidadEntity> unidadesDisponibles = [];
  List<CategoriaEntity> categoriasSeleccionadas = [];
  UnidadEntity? unidadSeleccionada;
  String? rutaImagen;

  ProductoController get _productoController =>
      ServiceLocator.productoController;
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
    final cats = await _categoriaController.obtenerTodas();
    final unis = await _unidadController.obtenerTodas();

    if (mounted) {
      setState(() {
        categoriasDisponibles = cats;
        unidadesDisponibles = unis;
      });
    }
  }

  @override
  void dispose() {
    productCodeController.dispose();
    productNameController.dispose();
    minStockController.dispose();
    priceController.dispose();

    super.dispose();
  }

  Widget _buildCategorySelection() {
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
          children: categoriasDisponibles.map((categoria) {
            final seleccionada =
                categoriasSeleccionadas.any((c) => c.idCategoria == categoria.idCategoria);

            return FilterChip(
              label: Text(categoria.nombre),
              selected: seleccionada,
              selectedColor: AppColors.primary,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: seleccionada ? Colors.white : AppColors.primary,
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    categoriasSeleccionadas.add(categoria);

                  } else {
                    categoriasSeleccionadas
                        .removeWhere((c) => c.idCategoria == categoria.idCategoria);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async {
                  rutaImagen = await context.push("/image-picker") as String?;

                  setState(() {});
                },
                icon: SizedBox(
                  width: 80,
                  height: 80,
                  child: rutaImagen == null
                      ? Image.asset(
                          'lib/assets/iconos/iconoImagen.png',
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(rutaImagen!),
                          fit: BoxFit.cover,
                        ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Código del producto',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productCodeController.text.isEmpty
                        ? "-" * 13
                        : productCodeController.text,
                    style: const TextStyle(fontSize: 24),
                  ),

                  const SizedBox(width: 10),

                  IconButton(
                    onPressed: () async {
                      final result = await context.push('/barcode-scanner');

                      if (result != null && result.toString().isNotEmpty) {
                        setState(() {
                          productCodeController.text = result.toString();
                        });
                      }
                    },
                    icon: Image.asset(
                      'lib/assets/iconos/iconoBarras.png',
                      height: 40,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildCategorySelection(),

              const SizedBox(height: 30),

              CustomTextField(
                label: 'Nombre del producto',
                controller: productNameController,
                keyboardType: TextInputType.text,
                isRequired: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<int>(
                  value: unidadSeleccionada?.idUnidad,
                  items: unidadesDisponibles
                      .map(
                        (u) => DropdownMenuItem<int>(
                          value: u.idUnidad,
                          child: Text(u.nombre),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(
                    () => unidadSeleccionada =
                        unidadesDisponibles.firstWhere((u) => u.idUnidad == value),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Unidad de medida *',
                    labelStyle: TextStyle(color: Colors.black87),
                    border: OutlineInputBorder(),
                  ),
                  isDense: true,
                  isExpanded: true,
                ),
              ),

              CustomTextField(
                label: 'Stock mínimo',
                controller: minStockController,
                keyboardType: TextInputType.number,
                isRequired: true,
                suffixText: unidadSeleccionada?.abreviatura,
              ),

              CustomTextField(
                label: 'Precio por medida',
                controller: priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                isPrice: true,
                isRequired: true,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => context.pop(),
                    child: const Text('Cancelar'),
                  ),

                  ElevatedButton(
                    style: ButtonStyles.success(),
                    onPressed: _confirmarProducto,
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmarProducto() {
    if (productNameController.text.isEmpty ||
        minStockController.text.isEmpty ||
        priceController.text.isEmpty ||
        unidadSeleccionada == null) {
      final (title, desc) = DialogMessages.inventario.camposIncompletos;
      ErrorDialog(
        context: context,
        title: title,
        description: desc,
      );

      return;
    }

    final precio = double.tryParse(priceController.text) ?? 0.0;
    final stockMin = double.tryParse(minStockController.text) ?? 0.0;

    if (stockMin <= 0) {
      final (title, desc) = DialogMessages.inventario.stockMinimoInvalido;
      ErrorDialog(
        context: context,
        title: title,
        description: desc,
      );

      return;
    }

    if (precio <= 0) {
      final (title, desc) = DialogMessages.inventario.precioInvalido;
      ErrorDialog(
        context: context,
        title: title,
        description: desc,
      );

      return;
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: 'Confirmación',
      desc: '¿Está seguro de que desea crear el producto?',
      btnOkOnPress: () async {
        final request = CrearProductoRequest(
          idUnidad: unidadSeleccionada!.idUnidad!,
          codigo: productCodeController.text != "-" * 13
              ? productCodeController.text
              : null,
          nombre: productNameController.text,
          precio: precio,
          stockMinimo: stockMin.round(),
          rutaImagen: rutaImagen,
        );

        try {
          final ids = categoriasSeleccionadas
              .map((c) => c.idCategoria!)
              .toList();

          await _productoController.crearProducto(
            request,
            idCategorias: ids,
          );

          if (mounted) {
            final (title, desc) = DialogMessages.inventario.productoregistrado;
            SuccessDialog(
              context: context,
              title: title,
              description: desc,
              btnOkOnPress: () => context.pop(),
            );
          }

        } catch (e) {
          final (title, desc) = DialogMessages.inventario.noSePudoRegistrarProducto;
          ErrorDialog(
            context: context,
            title: title,
            description: desc,
          );
        }
      },
      btnCancelOnPress: () {},
    ).show();
  }
}

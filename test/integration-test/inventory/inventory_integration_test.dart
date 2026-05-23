import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/features/inventory/entities/UnidadEntity.dart';
import 'package:iventi/features/inventory/entities/CategoriaEntity.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/repositories/UnidadRepository.dart';
import 'package:iventi/features/inventory/repositories/CategoriaRepository.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/inventory/services/UnidadService.dart';
import 'package:iventi/features/inventory/services/CategoriaService.dart';
import 'package:iventi/features/inventory/services/ProductoService.dart';
import 'package:iventi/features/inventory/services/LoteService.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearCategoriaRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarCategoriaRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/ActualizarLoteRequest.dart';
import 'package:iventi/features/sales/repositories/VentaRepository.dart';

void main() {
  late PostgresDatasource datasource;
  late UnidadService unidadService;
  late CategoriaService categoriaService;
  late ProductoService productoService;
  late LoteService loteService;
  late CategoriaRepository categoriaRepository;
  late ProductoRepository productoRepository;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    datasource = PostgresDatasource();

    final unidadRepository = UnidadRepository(datasource);
    unidadService = UnidadService(unidadRepository);

    categoriaRepository = CategoriaRepository(datasource);
    categoriaService = CategoriaService(categoriaRepository);

    productoRepository = ProductoRepository(datasource);
    final loteRepository = LoteRepository(datasource, productoRepository);
    final ventaRepository = VentaRepository(datasource, loteRepository, productoRepository);

    productoService = ProductoService(productoRepository, categoriaRepository);
    loteService = LoteService(loteRepository, productoRepository, ventaRepository);
  });

  setUp(() async {
    final conn = await datasource.connection;
    await conn.execute('BEGIN');
  });

  tearDown(() async {
    final conn = await datasource.connection;
    await conn.execute('ROLLBACK');
  });

  tearDownAll(() async {
    await datasource.close();
  });

  int _contador = 0;
  String _codigoUnico() =>
      'C${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}${_contador++}';

  // =========================================================================
  // UNIDAD SERVICE
  // =========================================================================
  group('UnidadService con BD real', () {
    test('debe obtener todas las unidades activas [en BD real]', () async {
      final resultado = await unidadService.obtenerTodas();

      expect(resultado, isNotEmpty);
      expect(resultado.any((u) => u.nombre == 'Unidad'), isTrue);
      expect(resultado.any((u) => u.nombre == 'Kilogramo'), isTrue);
      expect(resultado.every((u) => u.esActivo), isTrue);
    });

    test('debe obtener unidad por ID cuando existe [en BD real]', () async {
      final resultado = await unidadService.obtenerTodas();
      final primera = resultado.first;

      final unidad = await unidadService.obtenerPorId(primera.idUnidad!);

      expect(unidad, isNotNull);
      expect(unidad!.idUnidad, primera.idUnidad);
      expect(unidad.nombre, primera.nombre);
    });

    test('debe devolver null cuando la unidad no existe [en BD real]',
        () async {
      final unidad = await unidadService.obtenerPorId(-1);

      expect(unidad, isNull);
    });
  });

  // =========================================================================
  // CATEGORIA SERVICE
  // =========================================================================
  group('CategoriaService con BD real', () {
    test('debe crear una categoria correctamente [en BD real]', () async {
      final request = CrearCategoriaRequest(nombre: 'Test Categoria');

      final categoria = await categoriaService.crearCategoria(request);

      expect(categoria.idCategoria, isNotNull);
      expect(categoria.nombre, 'Test Categoria');
      expect(categoria.esActivo, true);
    });

    test('debe obtener todas las categorias activas [en BD real]', () async {
      final resultado = await categoriaService.obtenerTodas();

      expect(resultado, isNotEmpty);
      expect(resultado.any((c) => c.nombre == 'General'), isTrue);
      expect(resultado.any((c) => c.nombre == 'Alimentos'), isTrue);
      expect(resultado.every((c) => c.esActivo), isTrue);
    });

    test(
        'debe actualizar una categoria correctamente [en BD real]', () async {
      final creada = await categoriaService.crearCategoria(
          CrearCategoriaRequest(nombre: 'Original'));

      final actualizada = await categoriaService.actualizarCategoria(
          ActualizarCategoriaRequest(
              idCategoria: creada.idCategoria!, nombre: 'Actualizada'));

      expect(actualizada.nombre, 'Actualizada');
      expect(actualizada.idCategoria, creada.idCategoria);
    });

    test('debe eliminar (desactivar) una categoria correctamente [en BD real]',
        () async {
      final creada = await categoriaService.crearCategoria(
          CrearCategoriaRequest(nombre: 'Temp'));

      await categoriaService.eliminarCategoria(creada.idCategoria!);

      final categorias = await categoriaService.obtenerTodas();
      expect(categorias.any((c) => c.idCategoria == creada.idCategoria),
          isFalse);
    });

    test(
        'debe lanzar BusinessException al eliminar categoria inexistente [en BD real]',
        () async {
      expect(
        () => categoriaService.eliminarCategoria(-1),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe obtener categorias de un producto [en BD real]', () async {
      final categoria = await categoriaService.crearCategoria(
          CrearCategoriaRequest(nombre: 'CategProd'));
      final request = CrearProductoRequest(
        idUnidad: 1,
        nombre: 'Prod Test',
        precio: 10.0,
        idCategorias: [categoria.idCategoria!],
      );
      final producto = await productoService.crearProducto(
        request,
        idCategorias: [categoria.idCategoria!],
      );

      final categorias =
          await categoriaService.obtenerDeProducto(producto.idProducto!);

      expect(categorias, isNotEmpty);
      expect(categorias.any((c) => c.idCategoria == categoria.idCategoria),
          isTrue);
    });
  });

  // =========================================================================
  // PRODUCTO SERVICE
  // =========================================================================
  group('ProductoService con BD real', () {
    test('debe crear un producto correctamente [en BD real]', () async {
      final codigo = _codigoUnico();
      final request = CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'Producto Test',
        precio: 25.50,
        stockMinimo: 5,
      );

      final producto = await productoService.crearProducto(request);

      expect(producto.idProducto, isNotNull);
      expect(producto.nombre, 'Producto Test');
      expect(producto.codigo, codigo);
      expect(producto.idUnidad, 1);
      expect(producto.precio, 25.50);
      expect(producto.stockMinimo, 5);
      expect(producto.stockActual, 0);
      expect(producto.esActivo, true);
    });

    test(
        'debe lanzar BusinessException cuando el codigo ya existe [en BD real]',
        () async {
      final codigo = _codigoUnico();
      final request = CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'Original',
        precio: 10.0,
      );
      await productoService.crearProducto(request);

      final duplicado = CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'Duplicado',
        precio: 15.0,
      );

      expect(
        () => productoService.crearProducto(duplicado),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe obtener producto por ID [en BD real]', () async {
      final codigo = _codigoUnico();
      final creado = await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'Busqueda ID',
        precio: 10.0,
      ));

      final encontrado =
          await productoService.obtenerProductoPorId(creado.idProducto!);

      expect(encontrado, isNotNull);
      expect(encontrado!.idProducto, creado.idProducto);
    });

    test('debe devolver null cuando producto por ID no existe [en BD real]',
        () async {
      final encontrado = await productoService.obtenerProductoPorId(-1);

      expect(encontrado, isNull);
    });

    test('debe obtener producto por codigo [en BD real]', () async {
      final codigo = _codigoUnico();
      await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'Busqueda Cod',
        precio: 10.0,
      ));

      final encontrado =
          await productoService.obtenerProductoPorCodigo(codigo);

      expect(encontrado, isNotNull);
      expect(encontrado!.codigo, codigo);
    });

    test('debe devolver null cuando codigo no existe [en BD real]', () async {
      final encontrado =
          await productoService.obtenerProductoPorCodigo('CODIGO_INEXISTENTE');

      expect(encontrado, isNull);
    });

    test('debe buscar productos por nombre [en BD real]', () async {
      await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        nombre: 'Omega Test',
        precio: 10.0,
      ));

      final resultados = await productoService.buscarPorNombre('Omega');

      expect(resultados, isNotEmpty);
      expect(resultados.any((p) => p.nombre == 'Omega Test'), isTrue);
    });

    test('debe actualizar un producto correctamente [en BD real]', () async {
      final codigo = _codigoUnico();
      final creado = await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'Original',
        precio: 10.0,
      ));

      final actualizado = await productoService.actualizarProducto(
          ActualizarProductoRequest(
        idProducto: creado.idProducto!,
        idUnidad: 1,
        nombre: 'Actualizado',
        precio: 20.0,
      ));

      expect(actualizado.nombre, 'Actualizado');
      expect(actualizado.precio, 20.0);
    });

    test(
        'debe lanzar BusinessException al actualizar producto inexistente [en BD real]',
        () async {
      expect(
        () => productoService.actualizarProducto(ActualizarProductoRequest(
          idProducto: -1,
          idUnidad: 1,
          nombre: 'No Existe',
          precio: 1.0,
        )),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe eliminar (desactivar) un producto correctamente [en BD real]',
        () async {
      final codigo = _codigoUnico();
      final creado = await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'AEliminar',
        precio: 10.0,
      ));

      await productoService.eliminarProducto(creado.idProducto!);

      final encontrado =
          await productoService.obtenerProductoPorId(creado.idProducto!);
      expect(encontrado, isNull);
    });

    test(
        'debe lanzar BusinessException al eliminar producto inexistente [en BD real]',
        () async {
      expect(
        () => productoService.eliminarProducto(-1),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe obtener todos los productos activos [en BD real]', () async {
      final todos = await productoService.obtenerTodos();

      expect(todos.every((p) => p.esActivo), isTrue);
    });

    test('debe obtener productos filtrados por stock bajo [en BD real]',
        () async {
      await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        nombre: 'Stock Bajo Test',
        precio: 10.0,
        stockMinimo: 10,
      ));

      final conStockBajo = await productoService.obtenerFiltrados(
        limite: 10,
        offset: 0,
        stockBajo: true,
      );

      expect(conStockBajo.any((p) => p.stockActual < p.stockMinimo), isTrue);
    });
  });

  // =========================================================================
  // LOTE SERVICE
  // =========================================================================
  group('LoteService con BD real', () {
    Future<ProductoEntity> _crearProductoBase() async {
      final codigo = _codigoUnico();
      return await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        codigo: codigo,
        nombre: 'Producto Base Lote',
        precio: 10.0,
      ));
    }

    test('debe crear un lote correctamente [en BD real]', () async {
      final producto = await _crearProductoBase();
      final now = DateTime.now();

      final lote = await loteService.crearLote(CrearLoteRequest(
        idProducto: producto.idProducto!,
        fechaCompra: now,
        fechaVencimiento: now.add(const Duration(days: 90)),
        cantidadComprada: 100,
        precioCompra: 500.0,
      ));

      expect(lote.idLote, isNotNull);
      expect(lote.idProducto, producto.idProducto);
      expect(lote.cantidadComprada, 100);
      expect(lote.cantidadActual, 100);
      expect(lote.cantidadPerdida, 0);

      final productoActualizado =
          await productoService.obtenerProductoPorId(producto.idProducto!);
      expect(productoActualizado!.stockActual, 100);
    });

    test(
        'debe lanzar BusinessException cuando el producto no existe [en BD real]',
        () async {
      final now = DateTime.now();
      expect(
        () => loteService.crearLote(CrearLoteRequest(
          idProducto: -1,
          fechaCompra: now,
          fechaVencimiento: now.add(const Duration(days: 90)),
          cantidadComprada: 10,
          precioCompra: 100.0,
        )),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe obtener lote por ID [en BD real]', () async {
      final producto = await _crearProductoBase();
      final now = DateTime.now();
      final creado = await loteService.crearLote(CrearLoteRequest(
        idProducto: producto.idProducto!,
        fechaCompra: now,
        fechaVencimiento: now.add(const Duration(days: 90)),
        cantidadComprada: 50,
        precioCompra: 250.0,
      ));

      final encontrado = await loteService.obtenerLotePorId(
          producto.idProducto!, creado.idLote!);

      expect(encontrado, isNotNull);
      expect(encontrado!.idLote, creado.idLote);
    });

    test('debe obtener lotes de un producto [en BD real]', () async {
      final producto = await _crearProductoBase();
      final now = DateTime.now();
      await loteService.crearLote(CrearLoteRequest(
        idProducto: producto.idProducto!,
        fechaCompra: now,
        fechaVencimiento: now.add(const Duration(days: 90)),
        cantidadComprada: 30,
        precioCompra: 150.0,
      ));

      final lotes =
          await loteService.obtenerLotesDeProducto(producto.idProducto!);

      expect(lotes, isNotEmpty);
      expect(lotes.every((l) => l.idProducto == producto.idProducto), isTrue);
    });

    test('debe actualizar un lote correctamente [en BD real]', () async {
      final producto = await _crearProductoBase();
      final now = DateTime.now();
      final creado = await loteService.crearLote(CrearLoteRequest(
        idProducto: producto.idProducto!,
        fechaCompra: now,
        fechaVencimiento: now.add(const Duration(days: 90)),
        cantidadComprada: 100,
        precioCompra: 500.0,
      ));

      final actualizado = await loteService.actualizarLote(
          ActualizarLoteRequest(
        idProducto: producto.idProducto!,
        idLote: creado.idLote!,
        cantidadActual: 80,
        cantidadComprada: 100,
        precioCompra: 500.0,
        fechaCompra: now,
        fechaVencimiento: now.add(const Duration(days: 90)),
      ));

      expect(actualizado.cantidadActual, 80);
    });

    test('debe obtener lotes por fechas [en BD real]', () async {
      final producto = await _crearProductoBase();
      final now = DateTime.now();
      await loteService.crearLote(CrearLoteRequest(
        idProducto: producto.idProducto!,
        fechaCompra: now,
        fechaVencimiento: now.add(const Duration(days: 90)),
        cantidadComprada: 50,
        precioCompra: 200.0,
      ));

      final lotes = await loteService.obtenerLotesPorFechas(
        now.subtract(const Duration(days: 1)),
        now.add(const Duration(days: 1)),
      );

      expect(lotes, isNotEmpty);
    });
  });
}

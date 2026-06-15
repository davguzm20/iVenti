import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';
import 'package:iventi/features/inventory/services/ProductoService.dart';
import 'package:iventi/features/inventory/services/LoteService.dart';
import 'package:iventi/features/inventory/repositories/ProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/LoteRepository.dart';
import 'package:iventi/features/inventory/repositories/CategoriaRepository.dart';
import 'package:iventi/features/inventory/entities/ProductoEntity.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearProductoRequest.dart';
import 'package:iventi/features/inventory/dtos/requests/CrearLoteRequest.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/services/PagoService.dart';
import 'package:iventi/features/sales/repositories/VentaRepository.dart';
import 'package:iventi/features/sales/repositories/ReciboRepository.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/clients/services/ClienteService.dart';
import 'package:iventi/features/clients/repositories/ClienteRepository.dart';
import 'package:iventi/features/clients/entities/ClienteEntity.dart';
import 'package:iventi/features/clients/dtos/requests/CrearClienteRequest.dart';

void main() {
  late PostgresDatasource datasource;
  late ProductoRepository productoRepository;
  late LoteRepository loteRepository;
  late CategoriaRepository categoriaRepository;
  late ProductoService productoService;
  late LoteService loteService;

  late ClienteRepository clienteRepository;
  late ClienteService clienteService;
  late VentaRepository ventaRepository;
  late ReciboRepository reciboRepository;
  late VentaService ventaService;
  late PagoService pagoService;
  int testUserId = 0;

  int contador = 0;
  String codigoUnico() =>
      'C${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}${contador++}';

  setUpAll(() async {
    await dotenv.load(fileName: '.env.test');
    datasource = PostgresDatasource();
    final conn = await datasource.connection;
    await conn.execute("SET app.id_usuario = '1'");

    final userResult = await conn.execute(
      Sql.named(
        'INSERT INTO usuarios (rol, nombre, email, pin, creado_en, actualizado_en) '
        'VALUES (@rol, @nombre, @email, @pin, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) '
        'RETURNING id_usuario'),
      parameters: {
        'rol': 'ADMINISTRADOR',
        'nombre': 'Test User Venta',
        'email': 'venta.test.${DateTime.now().millisecondsSinceEpoch}@test.com',
        'pin': '123456',
      },
    );
    testUserId = userResult.first.toColumnMap()['id_usuario'] as int;
    await conn.execute("SET app.id_usuario = '$testUserId'");

    productoRepository = ProductoRepository(datasource);
    loteRepository = LoteRepository(datasource, productoRepository);
    categoriaRepository = CategoriaRepository(datasource);
    clienteRepository = ClienteRepository(datasource);
    ventaRepository = VentaRepository(datasource);
    reciboRepository = ReciboRepository(datasource);

    productoService = ProductoService(productoRepository, categoriaRepository);
    clienteService = ClienteService(clienteRepository);
    loteService = LoteService(loteRepository, productoRepository, ventaRepository);
    ventaService = VentaService(
      datasource, ventaRepository, productoRepository, loteRepository, clienteRepository);
    pagoService = PagoService(datasource, ventaRepository, reciboRepository, clienteRepository);
  });

  tearDownAll(() async {
    if (testUserId > 0) {
      final c2 = await datasource.connection;
      await c2.execute(
        Sql.named('DELETE FROM usuarios WHERE id_usuario = @id'),
        parameters: {'id': testUserId});
    }
  });

  Future<void> cleanupVenta(int idVenta) async {
    final conn = await datasource.connection;
    final detalles = await conn.execute(
      Sql.named('SELECT id_lote, cantidad FROM detalle_ventas WHERE id_venta = @id'),
      parameters: {'id': idVenta},
    );
    for (final d in detalles) {
      final row = d.toColumnMap();
      await conn.execute(
        Sql.named(
          'UPDATE lotes SET cantidad_actual = cantidad_actual + @cant WHERE id_lote = @id'),
        parameters: {'cant': row['cantidad'], 'id': row['id_lote']},
      );
      final loteData = await conn.execute(
        Sql.named('SELECT id_producto FROM lotes WHERE id_lote = @id'),
        parameters: {'id': row['id_lote']},
      );
      if (loteData.isNotEmpty) {
        await productoRepository.actualizarStockActual(
          loteData.first.toColumnMap()['id_producto'] as int);
      }
    }
    await conn.execute(
      Sql.named('DELETE FROM recibos WHERE id_venta = @id'),
      parameters: {'id': idVenta});
    await conn.execute(
      Sql.named('DELETE FROM detalle_ventas WHERE id_venta = @id'),
      parameters: {'id': idVenta});
    await conn.execute(
      Sql.named('DELETE FROM ventas WHERE id_venta = @id'),
      parameters: {'id': idVenta});
  }

  group('VentaService.crearVenta con BD real', () {
    late ProductoEntity sharedProducto;
    late LoteEntity sharedLote;
    late ClienteEntity sharedCliente;

    setUpAll(() async {
      sharedProducto = await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        nombre: 'Prod Venta Test ${codigoUnico()}',
        codigo: codigoUnico(),
        precio: 50.0,
        stockMinimo: 5,
      ));
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      sharedLote = await loteService.crearLote(CrearLoteRequest(
        idProducto: sharedProducto.idProducto!,
        fechaCompra: DateTime.now(),
        fechaVencimiento: tomorrow,
        cantidadComprada: 100,
        precioCompra: 30.0,
      ));
      sharedCliente = await clienteService.crearCliente(CrearClienteRequest(
        nombres: 'Cliente',
        dni: codigoUnico(),
      ));
    });

    tearDownAll(() async {
      await loteService.eliminarLote(sharedProducto.idProducto!, sharedLote.idLote!);
      await productoService.eliminarProducto(sharedProducto.idProducto!);
      await clienteService.eliminarCliente(sharedCliente.idCliente!);
    });

    test('debe lanzar BusinessException cuando el lote no existe [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final request = CrearVentaRequest(
        idCliente: sharedCliente.idCliente,
        idUsuario: testUserId,
        montoTotal: 100.0,
        montoCancelado: 100.0,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: -1,
            idLote: -1,
            cantidad: 1,
            precioUnitario: 100.0,
            subtotal: 100.0,
            ganancia: 70.0,
            descuento: 0,
          ),
        ],
      );

      expect(
        () => ventaService.crearVenta(request),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar BusinessException cuando el stock es insuficiente [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final request = CrearVentaRequest(
        idUsuario: testUserId,
        montoTotal: 10000.0,
        montoCancelado: 10000.0,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: sharedProducto.idProducto!,
            idLote: sharedLote.idLote!,
            cantidad: 999,
            precioUnitario: 100.0,
            subtotal: 10000.0,
            ganancia: 70.0,
            descuento: 0,
          ),
        ],
      );

      expect(
        () => ventaService.crearVenta(request),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar ValidationException cuando venta al contado sin monto completo [en BD real]',
        () async {
      expect(
        () => CrearVentaRequest(
          idUsuario: testUserId,
          montoTotal: 100.0,
          montoCancelado: 50.0,
          esCredito: false,
          detalles: [
            DetalleVentaRequest(
              idProducto: 1,
              idLote: 1,
              cantidad: 1,
              precioUnitario: 100.0,
              subtotal: 100.0,
              ganancia: 70.0,
              descuento: 0,
            ),
          ],
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('debe crear una venta correctamente [en BD real]', () async {
      final request = CrearVentaRequest(
        idCliente: sharedCliente.idCliente,
        idUsuario: testUserId,
        montoTotal: 100.0,
        montoCancelado: 100.0,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: sharedProducto.idProducto!,
            idLote: sharedLote.idLote!,
            cantidad: 5,
            precioUnitario: 20.0,
            subtotal: 100.0,
            ganancia: 50.0,
            descuento: 0,
          ),
        ],
      );

      final venta = await ventaService.crearVenta(request);

      expect(venta.idVenta, isNotNull);
      expect(venta.montoTotal, 100.0);
      expect(venta.montoCancelado, 100.0);
      expect(venta.idCliente, sharedCliente.idCliente);

      await cleanupVenta(venta.idVenta!);
    });
  });

  group('VentaService.obtenerVentaPorId con BD real', () {
    test('debe devolver null cuando la venta no existe [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await ventaService.obtenerVentaPorId(-1);

      expect(resultado, isNull);
    });
  });

  group('VentaService.obtenerVentasFiltradas con BD real', () {
    test('debe devolver lista vacia cuando no hay ventas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await ventaService.obtenerVentasFiltradas(limite: 10, offset: 0);

      expect(resultado, isEmpty);
    });
  });

  group('VentaService.obtenerVentasDeCliente con BD real', () {
    test('debe devolver lista vacia cuando el cliente no tiene ventas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await ventaService.obtenerVentasDeCliente(-1);

      expect(resultado, isEmpty);
    });
  });

  group('VentaService.obtenerDetallesDeVenta con BD real', () {
    test('debe devolver lista vacia cuando la venta no existe [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await ventaService.obtenerDetallesDeVenta(-1);

      expect(resultado, isEmpty);
    });
  });

  group('VentaService.anularVenta con BD real', () {
    test('debe lanzar BusinessException cuando la venta no existe [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      expect(
        () => ventaService.anularVenta(-1),
        throwsA(isA<BusinessException>()),
      );
    });
  });

  group('VentaService.obtenerCantidadVendidaPorLote con BD real', () {
    test('debe devolver 0 cuando el lote no tiene ventas [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      final resultado = await ventaService.obtenerCantidadVendidaPorLote(-1);

      expect(resultado, 0);
    });
  });

  group('PagoService con BD real', () {
    late ProductoEntity sharedProducto;
    late LoteEntity sharedLote;
    late ClienteEntity sharedCliente;

    setUpAll(() async {
      sharedProducto = await productoService.crearProducto(CrearProductoRequest(
        idUnidad: 1,
        nombre: 'Prod Pago Test ${codigoUnico()}',
        codigo: codigoUnico(),
        precio: 50.0,
        stockMinimo: 5,
      ));
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      sharedLote = await loteService.crearLote(CrearLoteRequest(
        idProducto: sharedProducto.idProducto!,
        fechaCompra: DateTime.now(),
        fechaVencimiento: tomorrow,
        cantidadComprada: 100,
        precioCompra: 30.0,
      ));
      sharedCliente = await clienteService.crearCliente(CrearClienteRequest(
        nombres: 'Cliente',
        dni: codigoUnico(),
      ));
    });

    tearDownAll(() async {
      await loteService.eliminarLote(sharedProducto.idProducto!, sharedLote.idLote!);
      await productoService.eliminarProducto(sharedProducto.idProducto!);
      await clienteService.eliminarCliente(sharedCliente.idCliente!);
    });

    test('debe lanzar BusinessException cuando el monto es <= 0 [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      expect(
        () => pagoService.registrarPago(1, 0, testUserId),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe lanzar BusinessException cuando la venta no existe [en BD real]', () async {
      final conn = await datasource.connection;
      await conn.execute('BEGIN');
      addTearDown(() => conn.execute('ROLLBACK'));

      expect(
        () => pagoService.registrarPago(-1, 100.0, testUserId),
        throwsA(isA<BusinessException>()),
      );
    });

    test('debe registrar un pago correctamente [en BD real]', () async {
      final ventaRequest = CrearVentaRequest(
        idCliente: sharedCliente.idCliente,
        idUsuario: testUserId,
        montoTotal: 200.0,
        montoCancelado: 0,
        esCredito: true,
        detalles: [
          DetalleVentaRequest(
            idProducto: sharedProducto.idProducto!,
            idLote: sharedLote.idLote!,
            cantidad: 5,
            precioUnitario: 40.0,
            subtotal: 200.0,
            ganancia: 50.0,
            descuento: 0,
          ),
        ],
      );
      final venta = await ventaService.crearVenta(ventaRequest);

      final recibo = await pagoService.registrarPago(venta.idVenta!, 100.0, testUserId);

      expect(recibo.idRecibo, isNotNull);
      expect(recibo.montoCancelado, 100.0);

      await cleanupVenta(venta.idVenta!);
    });
  });
}

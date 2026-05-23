import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';
import 'package:iventi/features/inventory/repositories/IProductoRepository.dart';
import 'package:iventi/features/inventory/repositories/ILoteRepository.dart';
import 'package:iventi/features/clients/repositories/IClienteRepository.dart';
import 'package:iventi/features/sales/repositories/IVentaRepository.dart';
import 'package:iventi/features/inventory/entities/LoteEntity.dart';

import '../../../mocks_mocks.dart';

final mockDatasource = MockPostgresDatasource();
final mockVentaRepository = MockIVentaRepository();
final mockProductoRepository = MockIProductoRepository();
final mockLoteRepository = MockILoteRepository();
final mockClienteRepository = MockIClienteRepository();

VentaService buildService() => VentaService(
  mockDatasource,
  mockVentaRepository,
  mockProductoRepository,
  mockLoteRepository,
  mockClienteRepository,
);

void main() {
  setUp(() {
    reset(mockDatasource);
    reset(mockVentaRepository);
    reset(mockProductoRepository);
    reset(mockLoteRepository);
    reset(mockClienteRepository);
  });

  group('VentaService.crearVenta', () {
    test('debe crear venta correctamente', () async {
      final request = CrearVentaRequest(
        idUsuario: 1,
        montoTotal: 100,
        montoCancelado: 100,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: 1,
            idLote: 1,
            cantidad: 2,
            precioUnitario: 50,
            subtotal: 100,
            ganancia: 20,
            descuento: 0,
          ),
        ],
      );

      final ventaEntity = VentaEntity(
        idVenta: 1,
        idCliente: null,
        idUsuario: 1,
        vendidoEn: DateTime.now(),
        montoTotal: 100,
        montoCancelado: 100,
        estado: EstadoVenta.PENDIENTE,
        esCredito: false,
        creadoEn: DateTime.now(),
      );

      final loteEntity = LoteEntity(
        idLote: 1,
        idProducto: 1,
        fechaCompra: DateTime.now().subtract(const Duration(days: 30)),
        fechaVencimiento: DateTime.now().add(const Duration(days: 30)),
        cantidadActual: 10,
        cantidadComprada: 10,
        cantidadPerdida: 0,
        precioCompra: 40,
        creadoEn: DateTime.now(),
      );

      when(mockLoteRepository.obtenerLotePorId(any, any))
          .thenAnswer((_) async => loteEntity);
      when(mockVentaRepository.crearVenta(request))
          .thenAnswer((_) async => ventaEntity);

      final result = await buildService().crearVenta(request);

      expect(result, equals(ventaEntity));
      verify(mockVentaRepository.crearVenta(request)).called(1);
    });

    test('debe lanzar BusinessException cuando lote no existe', () async {
      final request = CrearVentaRequest(
        idUsuario: 1,
        montoTotal: 100,
        montoCancelado: 100,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: 1,
            idLote: 1,
            cantidad: 2,
            precioUnitario: 50,
            subtotal: 100,
            ganancia: 20,
            descuento: 0,
          ),
        ],
      );

      when(mockLoteRepository.obtenerLotePorId(any, any))
          .thenAnswer((_) async => null);

      expect(
        () => buildService().crearVenta(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('no encontrado'))),
      );
    });

    test('debe lanzar BusinessException cuando stock insuficiente', () async {
      final loteEntity = LoteEntity(
        idLote: 1,
        idProducto: 1,
        fechaCompra: DateTime.now().subtract(const Duration(days: 30)),
        fechaVencimiento: DateTime.now().add(const Duration(days: 30)),
        cantidadActual: 1,
        cantidadComprada: 10,
        cantidadPerdida: 0,
        precioCompra: 40,
        creadoEn: DateTime.now(),
      );

      final request = CrearVentaRequest(
        idUsuario: 1,
        montoTotal: 100,
        montoCancelado: 100,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: 1,
            idLote: 1,
            cantidad: 5,
            precioUnitario: 50,
            subtotal: 100,
            ganancia: 20,
            descuento: 0,
          ),
        ],
      );

      when(mockLoteRepository.obtenerLotePorId(any, any))
          .thenAnswer((_) async => loteEntity);

      expect(
        () => buildService().crearVenta(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Stock insuficiente'))),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final request = CrearVentaRequest(
        idUsuario: 1,
        montoTotal: 100,
        montoCancelado: 100,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: 1,
            idLote: 1,
            cantidad: 2,
            precioUnitario: 50,
            subtotal: 100,
            ganancia: 20,
            descuento: 0,
          ),
        ],
      );

      when(mockLoteRepository.obtenerLotePorId(any, any))
          .thenAnswer((_) async => LoteEntity(
            idLote: 1,
            idProducto: 1,
            fechaCompra: DateTime.now().subtract(const Duration(days: 30)),
            fechaVencimiento: DateTime.now().add(const Duration(days: 30)),
            cantidadActual: 10,
            cantidadComprada: 10,
            cantidadPerdida: 0,
            precioCompra: 40,
            creadoEn: DateTime.now(),
          ));

      when(mockVentaRepository.crearVenta(request))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().crearVenta(request),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al crear venta'))),
      );
    });
  });

  group('VentaService.obtenerVentaPorId', () {
    test('debe retornar venta cuando existe', () async {
      final ventaEntity = VentaEntity(
        idVenta: 1,
        idCliente: null,
        idUsuario: 1,
        vendidoEn: DateTime.now(),
        montoTotal: 100,
        montoCancelado: 100,
        estado: EstadoVenta.PENDIENTE,
        esCredito: false,
        creadoEn: DateTime.now(),
      );

      when(mockVentaRepository.obtenerVentaPorId(1))
          .thenAnswer((_) async => ventaEntity);

      final result = await buildService().obtenerVentaPorId(1);

      expect(result, equals(ventaEntity));
    });

    test('debe retornar null cuando no existe', () async {
      when(mockVentaRepository.obtenerVentaPorId(any))
          .thenAnswer((_) async => null);

      final result = await buildService().obtenerVentaPorId(999);

      expect(result, isNull);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockVentaRepository.obtenerVentaPorId(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerVentaPorId(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener venta'))),
      );
    });
  });

  group('VentaService.obtenerVentasDeCliente', () {
    test('debe retornar lista de ventas del cliente', () async {
      final ventas = [
        VentaEntity(
          idVenta: 1,
          idCliente: 1,
          idUsuario: 1,
          vendidoEn: DateTime.now(),
          montoTotal: 100,
          montoCancelado: 100,
          estado: EstadoVenta.PENDIENTE,
          esCredito: false,
          creadoEn: DateTime.now(),
        ),
      ];

      when(mockVentaRepository.obtenerVentasDeCliente(1))
          .thenAnswer((_) async => ventas);

      final result = await buildService().obtenerVentasDeCliente(1);

      expect(result, equals(ventas));
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockVentaRepository.obtenerVentasDeCliente(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerVentasDeCliente(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener ventas del cliente'))),
      );
    });
  });

  group('VentaService.obtenerDetallesDeVenta', () {
    test('debe retornar detalles de venta', () async {
      final detalles = [
        DetalleVentaEntity(
          idVenta: 1,
          idLote: 1,
          cantidad: 2,
          precioUnitario: 50,
          subtotal: 100,
          descuento: 0,
          creadoEn: DateTime.now(),
        ),
      ];

      when(mockVentaRepository.obtenerDetallesPorVenta(1))
          .thenAnswer((_) async => detalles);

      final result = await buildService().obtenerDetallesDeVenta(1);

      expect(result, equals(detalles));
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockVentaRepository.obtenerDetallesPorVenta(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerDetallesDeVenta(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener detalles'))),
      );
    });
  });

  group('VentaService.obtenerVentasFiltradas', () {
    test('debe retornar ventas filtradas', () async {
      final ventas = [
        VentaEntity(
          idVenta: 1, idCliente: null, idUsuario: 1,
          vendidoEn: DateTime.now(), montoTotal: 100, montoCancelado: 100,
          estado: EstadoVenta.PENDIENTE, esCredito: false, creadoEn: DateTime.now(),
        ),
      ];

      when(mockVentaRepository.obtenerVentasPorFiltros(
        limite: anyNamed('limite'), offset: anyNamed('offset'),
        esAlContado: anyNamed('esAlContado'), fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
      )).thenAnswer((_) async => ventas);

      final result = await buildService().obtenerVentasFiltradas(limite: 10, offset: 0);

      expect(result, equals(ventas));
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockVentaRepository.obtenerVentasPorFiltros(
        limite: anyNamed('limite'), offset: anyNamed('offset'),
        esAlContado: anyNamed('esAlContado'), fechaInicio: anyNamed('fechaInicio'),
        fechaFinal: anyNamed('fechaFinal'),
      )).thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerVentasFiltradas(limite: 10, offset: 0),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al filtrar ventas'))),
      );
    });
  });

  group('VentaService.obtenerVentasPorFechas', () {
    test('debe retornar ventas por rango de fechas', () async {
      final ventas = [
        VentaEntity(
          idVenta: 1, idCliente: null, idUsuario: 1,
          vendidoEn: DateTime.now(), montoTotal: 100, montoCancelado: 100,
          estado: EstadoVenta.PENDIENTE, esCredito: false, creadoEn: DateTime.now(),
        ),
      ];

      when(mockVentaRepository.obtenerVentasPorFechas(any, any))
          .thenAnswer((_) async => ventas);

      final result = await buildService().obtenerVentasPorFechas(
        DateTime(2024, 1, 1), DateTime(2024, 12, 31),
      );

      expect(result, equals(ventas));
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockVentaRepository.obtenerVentasPorFechas(any, any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerVentasPorFechas(
          DateTime(2024, 1, 1), DateTime(2024, 12, 31),
        ),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener ventas por fechas'))),
      );
    });
  });

  group('VentaService.anularVenta', () {
    test('debe lanzar BusinessException cuando venta no existe', () async {
      when(mockVentaRepository.obtenerVentaPorId(any))
          .thenAnswer((_) async => null);

      expect(
        () => buildService().anularVenta(999),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Venta no encontrada'))),
      );
    });

    test('debe lanzar BusinessException cuando venta ya esta anulada', () async {
      final ventaEntity = VentaEntity(
        idVenta: 1,
        idCliente: null,
        idUsuario: 1,
        vendidoEn: DateTime.now(),
        montoTotal: 100,
        montoCancelado: 100,
        estado: EstadoVenta.ANULADA,
        esCredito: false,
        creadoEn: DateTime.now(),
      );

      when(mockVentaRepository.obtenerVentaPorId(any))
          .thenAnswer((_) async => ventaEntity);

      expect(
        () => buildService().anularVenta(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('ya esta anulada'))),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final ventaEntity = VentaEntity(
        idVenta: 1,
        idCliente: null,
        idUsuario: 1,
        vendidoEn: DateTime.now(),
        montoTotal: 100,
        montoCancelado: 100,
        estado: EstadoVenta.PENDIENTE,
        esCredito: false,
        creadoEn: DateTime.now(),
      );

      when(mockVentaRepository.obtenerVentaPorId(any))
          .thenAnswer((_) async => ventaEntity);
      when(mockDatasource.connection)
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().anularVenta(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al anular venta'))),
      );
    });
  });

  group('VentaService.obtenerCantidadVendidaPorLote', () {
    test('debe retornar cantidad vendida', () async {
      when(mockVentaRepository.obtenerCantidadVendidaPorLote(1))
          .thenAnswer((_) async => 10);

      final result = await buildService().obtenerCantidadVendidaPorLote(1);

      expect(result, equals(10));
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockVentaRepository.obtenerCantidadVendidaPorLote(any))
          .thenThrow(DatabaseException('Error de DB'));

      expect(
        () => buildService().obtenerCantidadVendidaPorLote(1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al obtener cantidad vendida'))),
      );
    });
  });
}

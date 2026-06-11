import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:postgres/postgres.dart';
import 'package:iventi/shared/exceptions/BusinessException.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/sales/services/PagoService.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';

import '../../../mocks_mocks.dart';

class _FakeConnection implements Connection {
  final List<String> executed = [];
  bool throwOnExecute = false;

  @override
  Future<Result> execute(Object query,
      {Object? parameters,
      bool ignoreRows = false,
      QueryMode? queryMode,
      Duration? timeout}) async {
    executed.add(query.toString());
    if (throwOnExecute) throw DatabaseException('Simulated DB error');
    return Result(rows: [], affectedRows: 0, schema: ResultSchema([]));
  }

  @override
  Future<Statement> prepare(Object query) =>
      throw UnimplementedError();

  @override
  Future<R> run<R>(Future<R> Function(Session session) fn,
          {SessionSettings? settings}) =>
      throw UnimplementedError();

  @override
  Future<R> runTx<R>(Future<R> Function(TxSession session) fn,
          {TransactionSettings? settings}) =>
      throw UnimplementedError();

  @override
  Future<void> close({bool force = false}) => Future.value();

  @override
  bool get isOpen => true;

  @override
  Future<void> get closed => Future.value();

  @override
  ConnectionInfo get info => throw UnimplementedError();

  @override
  Channels get channels => throw UnimplementedError();
}

final mockDatasource = MockPostgresDatasource();
final mockVentaRepository = MockIVentaRepository();
final mockReciboRepository = MockIReciboRepository();
final mockClienteRepository = MockIClienteRepository();
final fakeConnection = _FakeConnection();

PagoService buildService() => PagoService(
  mockDatasource,
  mockVentaRepository,
  mockReciboRepository,
  mockClienteRepository,
);

void main() {
  setUp(() {
    reset(mockDatasource);
    reset(mockVentaRepository);
    reset(mockReciboRepository);
    reset(mockClienteRepository);
    fakeConnection.throwOnExecute = false;
    fakeConnection.executed.clear();

    when(mockDatasource.connection).thenAnswer((_) async => fakeConnection);
  });

  group('PagoService.registrarPago', () {
    test('debe registrar pago correctamente', () async {
      final venta = VentaEntity(
        idVenta: 1, idUsuario: 1, montoTotal: 100, montoCancelado: 0,
        estado: EstadoVenta.PENDIENTE, esCredito: true, vendidoEn: DateTime.now(), creadoEn: DateTime.now(),
      );
      final recibo = ReciboEntity(
        idRecibo: 1, idVenta: 1, idUsuario: 1,
        montoCancelado: 50, pagadoEn: DateTime.now(), creadoEn: DateTime.now(),
      );

      when(mockVentaRepository.obtenerVentaPorId(1)).thenAnswer((_) async => venta);
      when(mockVentaRepository.actualizarMontoCanceladoVenta(1, 50.0)).thenAnswer((_) async {});
      when(mockReciboRepository.crearReciboConRequest(any)).thenAnswer((_) async => recibo);

      final result = await buildService().registrarPago(1, 50.0, 1);

      expect(result, recibo);
      verify(mockVentaRepository.obtenerVentaPorId(1)).called(1);
    });

    test('debe lanzar BusinessException cuando monto es <= 0', () async {
      expect(
        () => buildService().registrarPago(1, 0, 1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('mayor a 0'))),
      );
    });

    test('debe lanzar BusinessException cuando venta no existe', () async {
      when(mockVentaRepository.obtenerVentaPorId(any)).thenAnswer((_) async => null);

      expect(
        () => buildService().registrarPago(999, 50, 1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('no encontrada'))),
      );
    });

    test('debe lanzar BusinessException cuando venta esta anulada', () async {
      final venta = VentaEntity(
        idVenta: 1, idUsuario: 1, montoTotal: 100, montoCancelado: 0,
        estado: EstadoVenta.ANULADA, esCredito: true, vendidoEn: DateTime.now(), creadoEn: DateTime.now(),
      );
      when(mockVentaRepository.obtenerVentaPorId(1)).thenAnswer((_) async => venta);

      expect(
        () => buildService().registrarPago(1, 50, 1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('anulada'))),
      );
    });

    test('debe lanzar BusinessException cuando monto excede saldo pendiente', () async {
      final venta = VentaEntity(
        idVenta: 1, idUsuario: 1, montoTotal: 100, montoCancelado: 60,
        estado: EstadoVenta.PENDIENTE, esCredito: true, vendidoEn: DateTime.now(), creadoEn: DateTime.now(),
      );
      when(mockVentaRepository.obtenerVentaPorId(1)).thenAnswer((_) async => venta);

      expect(
        () => buildService().registrarPago(1, 50, 1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('excede'))),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      final venta = VentaEntity(
        idVenta: 1, idUsuario: 1, montoTotal: 100, montoCancelado: 0,
        estado: EstadoVenta.PENDIENTE, esCredito: true, vendidoEn: DateTime.now(), creadoEn: DateTime.now(),
      );
      when(mockVentaRepository.obtenerVentaPorId(1)).thenAnswer((_) async => venta);
      when(mockVentaRepository.actualizarMontoCanceladoVenta(any, any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().registrarPago(1, 50, 1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Error al registrar pago'))),
      );
    });

    test('debe hacer ROLLBACK y no COMMIT cuando crear recibo falla', () async {
      final venta = VentaEntity(
        idVenta: 1, idUsuario: 1, montoTotal: 100, montoCancelado: 0,
        estado: EstadoVenta.PENDIENTE, esCredito: true, vendidoEn: DateTime.now(), creadoEn: DateTime.now(),
      );
      when(mockVentaRepository.obtenerVentaPorId(1)).thenAnswer((_) async => venta);
      when(mockVentaRepository.actualizarMontoCanceladoVenta(1, 50.0)).thenAnswer((_) async {});
      when(mockReciboRepository.crearReciboConRequest(any))
          .thenThrow(DatabaseException('Error al crear recibo'));

      await expectLater(
        () => buildService().registrarPago(1, 50, 1),
        throwsA(isA<BusinessException>()),
      );

      expect(fakeConnection.executed, contains('BEGIN'));
      expect(fakeConnection.executed, contains('ROLLBACK'));
      expect(fakeConnection.executed, isNot(contains('COMMIT')));
    });
  });

  group('PagoService.registrarPagoCliente', () {
    test('debe lanzar BusinessException cuando monto es <= 0', () async {
      expect(
        () => buildService().registrarPagoCliente(1, 0, 1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('mayor a 0'))),
      );
    });

    test('debe lanzar BusinessException cuando cliente no existe', () async {
      when(mockClienteRepository.obtenerClientePorId(any)).thenAnswer((_) async => null);

      expect(
        () => buildService().registrarPagoCliente(999, 50, 1),
        throwsA(isA<BusinessException>().having((e) => e.mensaje, 'mensaje', contains('Cliente no encontrado'))),
      );
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockClienteRepository.obtenerClientePorId(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().registrarPagoCliente(1, 50, 1),
        throwsA(isA<BusinessException>()),
      );
    });

  });

  group('PagoService.obtenerRecibosDeVenta', () {
    test('debe retornar lista de recibos', () async {
      final recibos = [
        ReciboEntity(
          idRecibo: 1, idVenta: 1, idUsuario: 1,
          montoCancelado: 50, pagadoEn: DateTime.now(), creadoEn: DateTime.now(),
        ),
      ];
      when(mockReciboRepository.obtenerRecibosPorVenta(1)).thenAnswer((_) async => recibos);

      final result = await buildService().obtenerRecibosDeVenta(1);

      expect(result, recibos);
    });

    test('debe lanzar BusinessException cuando hay DatabaseException', () async {
      when(mockReciboRepository.obtenerRecibosPorVenta(any))
          .thenThrow(DatabaseException('Error BD'));

      expect(
        () => buildService().obtenerRecibosDeVenta(1),
        throwsA(isA<BusinessException>()),
      );
    });
  });
}

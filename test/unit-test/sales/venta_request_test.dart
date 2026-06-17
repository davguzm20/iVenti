import 'package:flutter_test/flutter_test.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/shared/exceptions/ValidationException.dart';

void main() {
  group('CrearVentaRequest', () {
    test('3 productos producen 3 detalles en la request', () {
      final request = CrearVentaRequest(
        idCliente: 1,
        idUsuario: 1,
        montoTotal: 150.0,
        montoCancelado: 150.0,
        esCredito: false,
        detalles: [
          DetalleVentaRequest(
            idProducto: 1, idLote: 1, cantidad: 1,
            precioUnitario: 50.0, subtotal: 50.0, descuento: 0,
          ),
          DetalleVentaRequest(
            idProducto: 2, idLote: 2, cantidad: 2,
            precioUnitario: 25.0, subtotal: 50.0, descuento: 0,
          ),
          DetalleVentaRequest(
            idProducto: 3, idLote: 3, cantidad: 1,
            precioUnitario: 50.0, subtotal: 50.0, descuento: 0,
          ),
        ],
      );

      expect(request.detalles.length, 3);
      expect(request.montoTotal, 150.0);
    });

    test('detalles vacios lanza ValidationException', () {
      expect(
        () => CrearVentaRequest(
          idCliente: 1,
          idUsuario: 1,
          montoTotal: 100.0,
          montoCancelado: 100.0,
          esCredito: false,
          detalles: [],
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('request sin idCliente lanza ValidationException', () {
      expect(
        () => CrearVentaRequest(
          idUsuario: 1,
          montoTotal: 50.0,
          montoCancelado: 50.0,
          esCredito: false,
          detalles: [
            DetalleVentaRequest(
              idProducto: 1, idLote: 1, cantidad: 1,
              precioUnitario: 50.0, subtotal: 50.0, descuento: 0,
            ),
          ],
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('request al contado con pago incompleto lanza ValidationException', () {
      expect(
        () => CrearVentaRequest(
          idCliente: 1,
          idUsuario: 1,
          montoTotal: 100.0,
          montoCancelado: 50.0,
          esCredito: false,
          detalles: [
            DetalleVentaRequest(
              idProducto: 1, idLote: 1, cantidad: 1,
              precioUnitario: 100.0, subtotal: 100.0, descuento: 0,
            ),
          ],
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('request a credito no necesita monto completo', () {
      final request = CrearVentaRequest(
        idCliente: 1,
        idUsuario: 1,
        montoTotal: 100.0,
        montoCancelado: 20.0,
        esCredito: true,
        detalles: [
          DetalleVentaRequest(
            idProducto: 1, idLote: 1, cantidad: 1,
            precioUnitario: 100.0, subtotal: 100.0, descuento: 0,
          ),
        ],
      );

      expect(request.esCredito, true);
      expect(request.montoCancelado, 20.0);
    });
  });
}

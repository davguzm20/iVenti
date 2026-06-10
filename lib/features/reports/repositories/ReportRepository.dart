import 'package:postgres/postgres.dart';
import 'package:iventi/shared/utils/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/reports/dtos/responses/VentaReportResponse.dart';
import 'package:iventi/features/reports/dtos/responses/ProductoVendidoResponse.dart';
import 'package:iventi/features/reports/dtos/responses/LoteReportResponse.dart';
import 'package:iventi/features/reports/mappers/VentaReportMapper.dart';
import 'package:iventi/features/reports/mappers/ProductoVendidoMapper.dart';
import 'package:iventi/features/reports/mappers/LoteReportMapper.dart';
import 'package:iventi/features/reports/repositories/IReportRepository.dart';

class ReportRepository implements IReportRepository {
  final PostgresDatasource _datasource;

  ReportRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  @override
  Future<List<VentaReportResponse>> obtenerVentas({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  }) async {
    final conexion = await _conexion;

    try {
      String sql = '''
        SELECT v.id_venta, v.codigo_boleta,
               COALESCE(c.nombres || ' ' || c.apellidos, 'Sin cliente') AS cliente,
               v.vendido_en AS fecha, v.monto_total, v.monto_cancelado,
               CASE WHEN v.es_credito THEN 'Crédito' ELSE 'Al contado' END AS tipo
        FROM ventas v
        LEFT JOIN clientes c ON v.id_cliente = c.id_cliente
        WHERE v.vendido_en BETWEEN @inicio AND @fin
      ''';

      if (tipo == 'Al contado') {
        sql += ' AND v.es_credito = FALSE';
      } else if (tipo == 'Crédito') {
        sql += ' AND v.es_credito = TRUE';
      }

      sql += ' ORDER BY v.vendido_en DESC';

      final resultado = await conexion.execute(
        Sql.named(sql),
        parameters: {
          'inicio': fechaInicio,
          'fin': DateTime(
            fechaFinal.year,
            fechaFinal.month,
            fechaFinal.day,
            23, 59, 59,
          ),
        },
      );

      return resultado
          .map((fila) => VentaReportMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener reporte de ventas: $e');
    }
  }

  @override
  Future<List<ProductoVendidoResponse>> obtenerProductosVendidos({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
  }) async {
    final conexion = await _conexion;

    try {
      final resultado = await conexion.execute(
        Sql.named('''
          SELECT p.nombre AS producto,
                 SUM(dv.cantidad) AS cantidad,
                 dv.precio_unitario,
                 SUM(dv.subtotal) AS subtotal
          FROM detalle_ventas dv
          INNER JOIN ventas v ON dv.id_venta = v.id_venta
          INNER JOIN lotes l ON dv.id_lote = l.id_lote
          INNER JOIN productos p ON l.id_producto = p.id_producto
          WHERE v.vendido_en BETWEEN @inicio AND @fin
            AND v.estado != 'ANULADA'
          GROUP BY p.nombre, dv.precio_unitario
          ORDER BY subtotal DESC
        '''),
        parameters: {
          'inicio': fechaInicio,
          'fin': DateTime(
            fechaFinal.year,
            fechaFinal.month,
            fechaFinal.day,
            23, 59, 59,
          ),
        },
      );

      return resultado
          .map((fila) => ProductoVendidoMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener productos vendidos: $e');
    }
  }

  @override
  Future<List<LoteReportResponse>> obtenerLotes({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  }) async {
    final conexion = await _conexion;

    try {
      String sql = '''
        SELECT l.id_lote, p.nombre AS producto,
               l.cantidad_actual, l.cantidad_comprada,
               l.fecha_vencimiento
        FROM lotes l
        INNER JOIN productos p ON l.id_producto = p.id_producto
        WHERE l.creado_en BETWEEN @inicio AND @fin
      ''';

      if (tipo == 'Actuales') {
        sql += ' AND l.cantidad_actual > 0';
      }

      sql += ' ORDER BY l.creado_en DESC';

      final resultado = await conexion.execute(
        Sql.named(sql),
        parameters: {
          'inicio': fechaInicio,
          'fin': DateTime(
            fechaFinal.year,
            fechaFinal.month,
            fechaFinal.day,
            23, 59, 59,
          ),
        },
      );

      return resultado
          .map((fila) => LoteReportMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener reporte de lotes: $e');
    }
  }

  @override
  Future<List<LoteReportResponse>> obtenerProximosVencer(int dias) async {
    final conexion = await _conexion;

    try {
      final resultado = await conexion.execute(
        Sql.named('''
          SELECT l.id_lote, p.nombre AS producto,
                 l.cantidad_actual, l.cantidad_comprada,
                 l.fecha_vencimiento
          FROM lotes l
          INNER JOIN productos p ON l.id_producto = p.id_producto
          WHERE l.fecha_vencimiento IS NOT NULL
            AND l.fecha_vencimiento BETWEEN CURRENT_DATE AND CURRENT_DATE + @dias * INTERVAL '1 day'
            AND l.cantidad_actual > 0
          ORDER BY l.fecha_vencimiento ASC
        '''),
        parameters: {'dias': dias},
      );

      return resultado
          .map((fila) => LoteReportMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener próximos a vencer: $e');
    }
  }

  @override
  Future<List<LoteReportResponse>> obtenerInventarioGeneral(DateTime fecha) async {
    final conexion = await _conexion;

    try {
      final resultado = await conexion.execute(
        Sql.named('''
          SELECT l.id_lote, p.nombre AS producto,
                 l.cantidad_actual, l.cantidad_comprada,
                 l.fecha_vencimiento
          FROM lotes l
          INNER JOIN productos p ON l.id_producto = p.id_producto
          WHERE l.cantidad_actual > 0
            AND l.creado_en <= @fecha
          ORDER BY p.nombre ASC
        '''),
        parameters: {
          'fecha': DateTime(fecha.year, fecha.month, fecha.day, 23, 59, 59),
        },
      );

      return resultado
          .map((fila) => LoteReportMapper.fromMap(fila.toColumnMap()))
          .toList();
    } catch (e) {
      throw DatabaseException('Error al obtener inventario general: $e');
    }
  }
}

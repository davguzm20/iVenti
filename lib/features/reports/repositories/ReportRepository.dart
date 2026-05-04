import 'package:postgres/postgres.dart';
import 'package:iventi/shared/datasources/PostgresDatasource.dart';
import 'package:iventi/shared/exceptions/DatabaseException.dart';
import 'package:iventi/features/reports/entities/VentaReportEntity.dart';
import 'package:iventi/features/reports/entities/ProductoVendidoEntity.dart';
import 'package:iventi/features/reports/entities/LoteReportEntity.dart';

class ReportRepository {
  final PostgresDatasource _datasource;

  ReportRepository(this._datasource);

  Future<Connection> get _conexion => _datasource.connection;

  Future<List<VentaReportEntity>> obtenerVentas({
    required DateTime fechaInicio,
    required DateTime fechaFinal,
    String? tipo,
  }) async {
    final conexion = await _conexion;

    try {
      String sql = '''
        SELECT v.id_venta, v.codigo_boleta,
               COALESCE(c.nombre, 'Sin cliente') AS cliente,
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

      return resultado.map((fila) {
        final mapa = fila.toColumnMap();
        return VentaReportEntity(
          idVenta: mapa['id_venta'] as int,
          codigoBoleta: (mapa['codigo_boleta'] ?? '') as String,
          cliente: mapa['cliente'] as String,
          fecha: mapa['fecha'] as DateTime,
          montoTotal: (mapa['monto_total'] as num).toDouble(),
          montoCancelado: (mapa['monto_cancelado'] as num).toDouble(),
          tipo: mapa['tipo'] as String,
        );
      }).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener reporte de ventas: $e');
    }
  }

  Future<List<ProductoVendidoEntity>> obtenerProductosVendidos({
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

      return resultado.map((fila) {
        final mapa = fila.toColumnMap();
        return ProductoVendidoEntity(
          producto: mapa['producto'] as String,
          cantidad: (mapa['cantidad'] as num).toInt(),
          precioUnitario: (mapa['precio_unitario'] as num).toDouble(),
          subtotal: (mapa['subtotal'] as num).toDouble(),
        );
      }).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener productos vendidos: $e');
    }
  }

  Future<List<LoteReportEntity>> obtenerLotes({
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

      return resultado.map((fila) {
        final mapa = fila.toColumnMap();
        return LoteReportEntity(
          idLote: mapa['id_lote'] as int,
          producto: mapa['producto'] as String,
          cantidadActual: (mapa['cantidad_actual'] as num).toInt(),
          cantidadComprada: (mapa['cantidad_comprada'] as num).toInt(),
          fechaVencimiento: mapa['fecha_vencimiento'] as DateTime?,
        );
      }).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener reporte de lotes: $e');
    }
  }

  Future<List<LoteReportEntity>> obtenerProximosVencer(int dias) async {
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

      return resultado.map((fila) {
        final mapa = fila.toColumnMap();
        return LoteReportEntity(
          idLote: mapa['id_lote'] as int,
          producto: mapa['producto'] as String,
          cantidadActual: (mapa['cantidad_actual'] as num).toInt(),
          cantidadComprada: (mapa['cantidad_comprada'] as num).toInt(),
          fechaVencimiento: mapa['fecha_vencimiento'] as DateTime?,
        );
      }).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener próximos a vencer: $e');
    }
  }

  Future<List<LoteReportEntity>> obtenerInventarioGeneral(DateTime fecha) async {
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

      return resultado.map((fila) {
        final mapa = fila.toColumnMap();
        return LoteReportEntity(
          idLote: mapa['id_lote'] as int,
          producto: mapa['producto'] as String,
          cantidadActual: (mapa['cantidad_actual'] as num).toInt(),
          cantidadComprada: (mapa['cantidad_comprada'] as num).toInt(),
          fechaVencimiento: mapa['fecha_vencimiento'] as DateTime?,
        );
      }).toList();
    } catch (e) {
      throw DatabaseException('Error al obtener inventario general: $e');
    }
  }
}

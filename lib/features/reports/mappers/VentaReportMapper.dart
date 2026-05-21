import 'package:iventi/features/reports/entities/VentaReportEntity.dart';
import 'package:iventi/features/reports/dtos/responses/VentaReportResponse.dart';

class VentaReportMapper {
  static VentaReportEntity fromResponse(VentaReportResponse response) {
    return VentaReportEntity(
      idVenta: response.idVenta,
      codigoBoleta: response.codigoBoleta,
      cliente: response.cliente,
      fecha: response.fecha,
      montoTotal: response.montoTotal,
      montoCancelado: response.montoCancelado,
      tipo: response.tipo,
    );
  }

  static VentaReportResponse fromMap(Map<String, dynamic> map) {
    return VentaReportResponse(
      idVenta: map['id_venta'] as int,
      codigoBoleta: (map['codigo_boleta'] ?? '') as String,
      cliente: map['cliente'] as String,
      fecha: map['fecha'] as DateTime,
      montoTotal: (map['monto_total'] as num).toDouble(),
      montoCancelado: (map['monto_cancelado'] as num).toDouble(),
      tipo: map['tipo'] as String,
    );
  }
}

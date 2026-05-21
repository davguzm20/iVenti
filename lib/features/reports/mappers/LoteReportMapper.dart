import 'package:iventi/features/reports/entities/LoteReportEntity.dart';
import 'package:iventi/features/reports/dtos/responses/LoteReportResponse.dart';

class LoteReportMapper {
  static LoteReportEntity fromResponse(LoteReportResponse response) {
    return LoteReportEntity(
      idLote: response.idLote,
      producto: response.producto,
      cantidadActual: response.cantidadActual,
      cantidadComprada: response.cantidadComprada,
      fechaVencimiento: response.fechaVencimiento,
    );
  }

  static LoteReportResponse fromMap(Map<String, dynamic> map) {
    return LoteReportResponse(
      idLote: map['id_lote'] as int,
      producto: map['producto'] as String,
      cantidadActual: (map['cantidad_actual'] as num).toInt(),
      cantidadComprada: (map['cantidad_comprada'] as num).toInt(),
      fechaVencimiento: map['fecha_vencimiento'] as DateTime?,
    );
  }
}

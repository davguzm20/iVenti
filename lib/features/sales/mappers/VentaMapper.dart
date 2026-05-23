import 'package:iventi/shared/utils/PgHelper.dart';
import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/dtos/responses/VentaResponse.dart';
import 'package:iventi/features/sales/dtos/responses/DetalleVentaResponse.dart';
import 'package:iventi/features/sales/enums/EstadoVenta.dart';

class VentaMapper {
  static VentaEntity fromMap(Map<String, dynamic> map) {
    return VentaEntity(
      idVenta: map['id_venta'] as int,
      idCliente: map['id_cliente'] as int?,
      idUsuario: map['id_usuario'] as int,
      vendidoEn: map['vendido_en'] as DateTime,
      montoTotal: double.parse(map['monto_total'].toString()),
      montoCancelado: double.parse(map['monto_cancelado'].toString()),
      estado: _parseEstado(PgHelper.string(map['estado'])),
      esCredito: map['es_credito'] as bool,
      creadoEn: map['creado_en'] as DateTime,
      actualizadoEn: map['actualizado_en'] as DateTime?,
    );
  }

  static Map<String, dynamic> toMap(VentaEntity entity) {
    return {
      'id_cliente': entity.idCliente,
      'id_usuario': entity.idUsuario,
      'vendido_en': entity.vendidoEn,
      'monto_total': entity.montoTotal,
      'monto_cancelado': entity.montoCancelado,
      'estado': entity.estado.name,
      'es_credito': entity.esCredito,
    };
  }

  static VentaResponse toResponse(VentaEntity entity) {
    return VentaResponse(
      idVenta: entity.idVenta!,
      idCliente: entity.idCliente,
      idUsuario: entity.idUsuario,
      vendidoEn: entity.vendidoEn,
      montoTotal: entity.montoTotal,
      montoCancelado: entity.montoCancelado,
      estado: entity.estado,
      esCredito: entity.esCredito,
      creadoEn: entity.creadoEn,
      actualizadoEn: entity.actualizadoEn,
    );
  }

  static EstadoVenta _parseEstado(String estado) {
    switch (estado) {
      case 'COMPLETADA': return EstadoVenta.COMPLETADA;
      case 'ANULADA': return EstadoVenta.ANULADA;
      default: return EstadoVenta.PENDIENTE;
    }
  }
}

class DetalleVentaMapper {
  static DetalleVentaEntity fromMap(Map<String, dynamic> map) {
    return DetalleVentaEntity(
      idDetalleVenta: map['id_detalle_venta'] as int,
      idVenta: map['id_venta'] as int,
      idLote: map['id_lote'] as int,
      cantidad: map['cantidad'] as int,
      precioUnitario: double.parse(map['precio_unitario'].toString()),
      subtotal: double.parse(map['subtotal'].toString()),
      descuento: double.parse(map['descuento'].toString()),
      creadoEn: map['creado_en'] as DateTime,
    );
  }

  static Map<String, dynamic> toMap(DetalleVentaEntity entity) {
    return {
      'id_venta': entity.idVenta,
      'id_lote': entity.idLote,
      'cantidad': entity.cantidad,
      'precio_unitario': entity.precioUnitario,
      'subtotal': entity.subtotal,
      'descuento': entity.descuento,
    };
  }

  static DetalleVentaResponse toResponse(DetalleVentaEntity entity) {
    return DetalleVentaResponse(
      idDetalleVenta: entity.idDetalleVenta!,
      idVenta: entity.idVenta,
      idLote: entity.idLote,
      cantidad: entity.cantidad,
      precioUnitario: entity.precioUnitario,
      subtotal: entity.subtotal,
      descuento: entity.descuento,
      creadoEn: entity.creadoEn,
    );
  }
}

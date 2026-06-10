import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/entities/ReciboEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';
import 'package:iventi/features/sales/services/VentaService.dart';
import 'package:iventi/features/sales/services/PagoService.dart';

class VentaController {
  final VentaService _ventaService;
  final PagoService _pagoService;

  VentaController(this._ventaService, this._pagoService);

  Future<VentaEntity> crearVenta(CrearVentaRequest request) {
    return _ventaService.crearVenta(request);
  }

  Future<VentaEntity?> obtenerVentaPorId(int idVenta) {
    return _ventaService.obtenerVentaPorId(idVenta);
  }

  Future<List<VentaEntity>> obtenerVentasFiltradas({
    required int limite,
    required int offset,
    bool? esAlContado,
    DateTime? fechaInicio,
    DateTime? fechaFinal,
  }) {
    return _ventaService.obtenerVentasFiltradas(
      limite: limite,
      offset: offset,
      esAlContado: esAlContado,
      fechaInicio: fechaInicio,
      fechaFinal: fechaFinal,
    );
  }

  Future<List<VentaEntity>> obtenerVentasDeCliente(int idCliente) {
    return _ventaService.obtenerVentasDeCliente(idCliente);
  }

  Future<List<VentaEntity>> obtenerVentasPorFechas(DateTime fechaInicio, DateTime fechaFinal) {
    return _ventaService.obtenerVentasPorFechas(fechaInicio, fechaFinal);
  }

  Future<List<DetalleVentaEntity>> obtenerDetallesDeVenta(int idVenta) {
    return _ventaService.obtenerDetallesDeVenta(idVenta);
  }

  Future<void> anularVenta(int idVenta) {
    return _ventaService.anularVenta(idVenta);
  }

  Future<ReciboEntity> registrarPago(int idVenta, double monto, int idUsuario) {
    return _pagoService.registrarPago(idVenta, monto, idUsuario);
  }

  Future<void> registrarPagoCliente(int idCliente, double monto, int idUsuario) {
    return _pagoService.registrarPagoCliente(idCliente, monto, idUsuario);
  }

  Future<List<ReciboEntity>> obtenerRecibosDeVenta(int idVenta) {
    return _pagoService.obtenerRecibosDeVenta(idVenta);
  }

  Future<int> obtenerCantidadVendidaPorLote(int idLote) {
    return _ventaService.obtenerCantidadVendidaPorLote(idLote);
  }
}

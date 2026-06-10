import 'package:iventi/features/sales/entities/VentaEntity.dart';
import 'package:iventi/features/sales/entities/DetalleVentaEntity.dart';
import 'package:iventi/features/sales/dtos/requests/CrearVentaRequest.dart';

abstract class IVentaRepository {
  Future<VentaEntity> crearVenta(CrearVentaRequest request);
  Future<VentaEntity?> obtenerVentaPorId(int idVenta);
  Future<List<VentaEntity>> obtenerVentasPorFiltros({
    required int limite, required int offset,
    bool? esAlContado, DateTime? fechaInicio, DateTime? fechaFinal,
  });
  Future<List<VentaEntity>> obtenerVentasDeCliente(int idCliente, {bool esAlContado = false});
  Future<List<VentaEntity>> obtenerVentasPorFechas(DateTime fechaInicio, DateTime fechaFinal);
  Future<List<DetalleVentaEntity>> obtenerDetallesPorVenta(int idVenta);
  Future<void> anularVenta(int idVenta);
  Future<void> actualizarMontoCanceladoVenta(int idVenta, double montoACancelar);
  Future<void> actualizarMontoCanceladoVentasCliente(int idCliente, double montoACancelar);
  Future<int> obtenerCantidadVendidaPorLote(int idLote);
}
